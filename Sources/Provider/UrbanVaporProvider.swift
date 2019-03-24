//
//  UrbanVaporProvider.swift
//  App
//
//  Created by William McGinty on 5/5/18.
//

import Foundation
import Vapor

public struct UrbanVaporProvider: Provider {
    
    // MARK: Properties
    public let airshipKey: String
    public let airshipMasterSecret: String
    
    /// Create a new UrbanVapor provider
    public init(key: String, secret: String) {
        airshipKey = key
        airshipMasterSecret = secret
    }
    
    /// See Provider.register
    public func register(_ services: inout Services) throws {
        let urbanVaporService = UrbanVaporService(key: airshipKey, secret: airshipMasterSecret)
        services.register(urbanVaporService, as: UrbanVaporService.self)
        
        var contentConfig = ContentConfig.default()
        contentConfig.use(decoder: UAJSONDecoder(), for: .uaJSON)
        services.register(contentConfig)
    }
    
    /// See Provider.boot
    public func didBoot(_ worker: Container) throws -> Future<Void> {
        return .done(on: worker)
    }
}

fileprivate extension MediaType {
    static let uaJSON = MediaType(type: "application", subType: "vnd.urbanairship+json", parameters: ["version": "3"])
}

fileprivate struct UAJSONDecoder: HTTPMessageDecoder, DataDecoder {
    
    func decode<D>(_ decodable: D.Type, from data: Data) throws -> D where D : Decodable {
        return try JSONDecoder().decode(D.self, from: data)
    }
    
    func decode<D, M>(_ decodable: D.Type, from message: M, maxSize: Int, on worker: Worker) throws -> EventLoopFuture<D> where D : Decodable, M : HTTPMessage {
        return message.body.consumeData(max: maxSize, on: worker).map(to: D.self) { data in
            return try JSONDecoder().decode(D.self, from: data)
        }
    }
}
