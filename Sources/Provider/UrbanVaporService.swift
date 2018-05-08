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
        return HTTPHeaders.authorizationHeaders(withKey: airshipKey, secret: airshipMasterSecret)
    }
}

public extension UrbanVaporService {
    
    //MARK: Endpoint
    private enum Endpoint {
        private static let baseURL = URL(string: "https://go.urbanairship.com/api/")!
        
        case push
        case validate
        case associateNamedUser
        case disassociateNamedUser
        
        var url: URL {
            switch self {
            case .push: return Endpoint.baseURL.appendingPathComponent("push")
            case .validate: return Endpoint.push.url.appendingPathComponent("validate")
            case .associateNamedUser: return Endpoint.baseURL.appendingPathComponents(["named_users", "associate"])
            case .disassociateNamedUser: return Endpoint.baseURL.appendingPathComponents(["named_users", "disassociate"])
            }
        }
    }
    
    // MARK: Interface
    func send(push: Push, on client: Client) throws -> Future<Response> {
        return try send(body: push, to: .push, on: client)
    }
    
    func send(pushes: [Push], on client: Client) throws -> Future<Response> {
        return try send(body: pushes, to: .push, on: client)
    }
    
    func validate(push: Push, on client: Client) throws -> Future<Response> {
        return try send(body: push, to: .validate, on: client)
    }
    
    func validate(pushes: [Push], on client: Client) throws -> Future<Response> {
        return try send(body: pushes, to: .push, on: client)
    }
    
    func associate(namedUser: NamedUserAssocation, on client: Client) throws -> Future<Response> {
        return try send(body: namedUser, to: .associateNamedUser, on: client)
    }
    
    func disassociate(namedUser: NamedUserAssocation, on client: Client) throws -> Future<Response> {
        return try send(body: namedUser, to: .disassociateNamedUser, on: client)
    }
}

// MARK: Helper
private extension UrbanVaporService {
    
    private func send<T: Encodable>(body: T, to endpoint: Endpoint, on client: Client) throws -> Future<Response> {
        return client.post(endpoint.url, headers: authorizationHeaders) { req in
            let encoder = JSONEncoder()
            if #available(OSX 10.12, *) {
                encoder.dateEncodingStrategy = .iso8601
            }
            
            req.http.body = HTTPBody(data: try encoder.encode(body))
        }
    }
}
