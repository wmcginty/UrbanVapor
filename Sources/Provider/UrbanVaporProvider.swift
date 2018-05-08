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
    }
    
    /// See Provider.boot
    public func didBoot(_ worker: Container) throws -> Future<Void> {
        return .done(on: worker)
    }
}
