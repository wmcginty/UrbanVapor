//
//  UrbanVaporService.swift
//  App
//
//  Created by William McGinty on 5/5/18.
//

import Foundation
import Vapor

public struct UrbanVaporService: Service {
    
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

public extension UrbanVaporService {
    
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
        
        var url: URL {
            switch self {
            case .push: return Endpoint.baseURL.appendingPathComponent("push")
            case .validate: return Endpoint.push.url.appendingPathComponent("validate")
            case .namedUser(let association): return Endpoint.baseURL.appendingPathComponents(["named_users", association.pathValue])
            }
        }
    }
    
    // MARK: Interface
    func send(_ push: Push, on request: Request, validateOnly: Bool = false) throws -> Future<HTTPStatus> {
        return try send(body: push, to: validateOnly ? .validate : .push, on: request).mapStatus(on: request)
    }
    
    func associate(_ namedUser: NamedUserAssocation, on request: Request) throws -> Future<HTTPStatus> {
        return try send(body: namedUser, to: .namedUser(action: .associate), on: request).mapStatus(on: request)
    }
    
    func disassociate(_ namedUser: NamedUserAssocation, on request: Request) throws -> Future<HTTPStatus> {
        return try send(body: namedUser, to: .namedUser(action: .disassociate), on: request).mapStatus(on: request)
    }
}
// MARK: Helper
extension Future where T: Response {
    
    func mapStatus(on worker: Request) throws -> Future<HTTPStatus> {
        return flatMap { response in
            guard response.http.status.isSuccess else {
                return try response.content.decode(UrbanError.self).map { urbanError in
                    throw UrbanAbortError(status: response.http.status, urbanError: urbanError)
                }
            }
            
            return Future.map(on: worker) { response.http.status }
        }
    }
}

extension UrbanVaporService {
    private func send<T: Encodable>(body: T, to endpoint: Endpoint, on request: Request) throws -> Future<Response> {
        let client = try request.client()
        return client.post(endpoint.url, headers: authorizationHeaders) { req in
            let encoder = JSONEncoder.custom(dates: .airship)            
            req.http.body = HTTPBody(data: try encoder.encode(body))
        }
    }
}
