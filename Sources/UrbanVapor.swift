//
//  UrbanVapor.swift
//  App
//
//  Created by William McGinty on 5/5/18.
//

import Foundation
import Vapor

// MARK: UrbanVapor Access
public extension Request {
    
    func configureUrbanVapor(withKey key: String, secret: String) {
        storage[UrbanVaporAPIKey.self] = key
        storage[UrbanVaporAPISecret.self] = secret
        
        ContentConfiguration.global.use(decoder: UAJSONDecoder(), for: .uaJSON)
    }
    
    var urbanVapor: UrbanVapor {
        guard let key = storage[UrbanVaporAPIKey.self], let secret = storage[UrbanVaporAPISecret.self] else {
            fatalError()
        }
        
        return UrbanVapor(key: key, secret: secret)
    }
}

// MARK: Key and Secret Storage
private struct UrbanVaporAPIKey: StorageKey {
    typealias Value = String
}

private struct UrbanVaporAPISecret: StorageKey {
    typealias Value = String
}

// MARK: UA Content Type
private extension HTTPMediaType {
    static let uaJSON = HTTPMediaType(type: "application", subType: "vnd.urbanairship+json", parameters: ["version": "3"])
}

private struct UAJSONDecoder: ContentDecoder {
    func decode<D>(_ decodable: D.Type, from body: ByteBuffer, headers: HTTPHeaders) throws -> D where D : Decodable {
        return try JSONDecoder().decode(decodable, from: body)
    }
}

// MARK: UrbanVapor
public struct UrbanVapor {
    
    // MARK: Properties
    public let airshipKey: String
    public let airshipMasterSecret: String
    
    /// Create a new UrbanVapor provider
    public init(key: String, secret: String) {
        airshipKey = key
        airshipMasterSecret = secret
    }
    
    private var authorizationHeaders: HTTPHeaders {
        return HTTPHeaders().withAuthorization(forKey: airshipKey, secret: airshipMasterSecret)
    }
}

// MARK: Network Requests
public extension UrbanVapor {
    
    //MARK: Endpoint
    private enum Endpoint {
        private static let baseURL = URL(string: "https://go.urbanairship.com/api/")!
        
        case push
        case validate
        case namedUser(action: NamedUserAction)
        
        enum NamedUserAction {
            case associate
            case disassociate
            
            var pathValue: String {
                switch self {
                case .associate: return "associate"
                case .disassociate: return "disassociate"
                }
            }
        }
        
        var uri: URI {
            switch self {
            case .push: return URI(string: Endpoint.baseURL.appendingPathComponent("push").absoluteString)
            case .validate: return URI(string: Endpoint.baseURL.appendingPathComponents(["push", "validate"]).absoluteString)
            case .namedUser(let association): return URI(string: Endpoint.baseURL.appendingPathComponents(["named_users", association.pathValue]).absoluteString)
            }
        }
    }
    
    func send(_ push: Push, on request: Request, validateOnly: Bool = false) throws -> EventLoopFuture<HTTPStatus> {
        return try send(body: push, to: validateOnly ? .validate : .push, on: request).mapStatus(on: request)
    }
    
    func associate(_ namedUser: NamedUserAssocation, on request: Request) throws -> EventLoopFuture<HTTPStatus> {
        return try send(body: namedUser, to: .namedUser(action: .associate), on: request).mapStatus(on: request)
    }
    
    func disassociate(_ namedUser: NamedUserAssocation, on request: Request) throws -> EventLoopFuture<HTTPStatus> {
        return try send(body: namedUser, to: .namedUser(action: .disassociate), on: request).mapStatus(on: request)
    }
}

// MARK: Helper
private extension UrbanVapor {
    
    private func send<T: Encodable>(body: T, to endpoint: Endpoint, on request: Request) throws -> EventLoopFuture<ClientResponse> {
        return request.client.post(endpoint.uri, headers: authorizationHeaders) { req in
            let encoder = JSONEncoder.custom(dates: .airship)
            try req.body?.setJSONEncodable(body, encoder: encoder, at: 0)
        }
    }
}

// MARK: Helper
private extension EventLoopFuture where Value == ClientResponse {
    
    func mapStatus(on worker: Request) throws -> EventLoopFuture<HTTPStatus> {
        return flatMap { response in
            guard response.status.isSuccess else {
                do {
                    let urbanError = try response.content.decode(UrbanError.self)
                    return worker.eventLoop.makeFailedFuture(UrbanAbortError(status: response.status, urbanError: urbanError))
                } catch {
                    return worker.eventLoop.makeFailedFuture(error)
                }
            }
            
            return worker.eventLoop.makeSucceededFuture(response.status)
        }
    }
}
