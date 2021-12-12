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
    
    var urbanVapor: UrbanVapor {
        return application.urbanVapor
    }
}

public extension Application {
    
    func configureUrbanVapor(withKey key: String, secret: String) {
        storage[UrbanVaporAPIKey.self] = key
        storage[UrbanVaporAPISecret.self] = secret
        
        ContentConfiguration.global.use(decoder: UAJSONDecoder(), for: .uaJSON)
    }
    
    var urbanVapor: UrbanVapor {
        guard let key = storage[UrbanVaporAPIKey.self], let secret = storage[UrbanVaporAPISecret.self] else {
            fatalError("Could not properly configure UrbanVapor")
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
    
    func send(_ push: Push, using client: Client, validateOnly: Bool = false) async throws -> HTTPStatus {
        return try await send(body: push, to: validateOnly ? .validate : .push, using: client).httpStatus()
    }
    
    func associate(_ namedUser: NamedUserAssocation, using client: Client) async throws -> HTTPStatus {
        return try await send(body: namedUser, to: .namedUser(action: .associate), using: client).httpStatus()
    }
    
    func disassociate(_ namedUser: NamedUserAssocation, using client: Client) async throws -> HTTPStatus {
        return try await send(body: namedUser, to: .namedUser(action: .disassociate), using: client).httpStatus()
    }
}

// MARK: Helper
private extension UrbanVapor {
    
    //MARK: Endpoint
    enum Endpoint {
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
    
    func send<T: Encodable>(body: T, to endpoint: Endpoint, using client: Client) async throws -> ClientResponse {
        return try await client.post(endpoint.uri, headers: authorizationHeaders) { req in
            let encoder = JSONEncoder.custom(dates: .airship)
            try req.content.encode(body, using: encoder)
        }
    }
}

// MARK: Helper
private extension ClientResponse {
    
    func httpStatus() throws -> HTTPStatus {
        guard status.isSuccess else {
            let urbanError = try content.decode(UrbanError.self)
            throw UrbanAbortError(status: status, urbanError: urbanError)
        }
        
        return status
    }
}
