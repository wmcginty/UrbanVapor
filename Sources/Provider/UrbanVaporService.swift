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
    func send(_ push: Push, on client: Client, validateOnly: Bool = false) throws -> Future<Response> {
        return try send(body: push, to: validateOnly ? .validate : .push, on: client)
    }
    
    func associate(_ namedUser: NamedUserAssocation, on client: Client) throws -> Future<Response> {
        return try send(body: namedUser, to: .namedUser(action: .associate), on: client)
    }
    
    func disassociate(_ namedUser: NamedUserAssocation, on client: Client) throws -> Future<Response> {
        return try send(body: namedUser, to: .namedUser(action: .disassociate), on: client)
    }
}

// MARK: Helper
private extension UrbanVaporService {
    
    private func send<T: Encodable>(body: T, to endpoint: Endpoint, on client: Client) throws -> Future<Response> {
        return client.post(endpoint.url, headers: authorizationHeaders) { req in
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .airship

            req.http.body = HTTPBody(data: try encoder.encode(body))
        }
    }
}
