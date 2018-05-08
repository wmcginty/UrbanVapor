//
//  DeviceTypes.swift
//  App
//
//  Created by William McGinty on 5/7/18.
//

import Foundation

public enum DeviceType: Int, Codable {
    case android = 1
    case amazon = 2
    case ios = 4
    case web = 8
    case wns = 16
    
    var stringValue: String {
        switch self {
        case .android: return "android"
        case .amazon: return "amazon"
        case .ios: return "ios"
        case .web: return "web"
        case .wns: return "wns"
        }
    }
}

public struct DeviceTypes: Collection, Equatable {
    
    // MARK: Properties
    private var storage: Set<DeviceType> = []
    
    // MARK: Initializer
    public init(deviceTypes: [DeviceType]) {
        storage = Set(deviceTypes)
    }
    
    // MARK: Interface
    public mutating func insert(_ deviceType: DeviceType) {
        storage.insert(deviceType)
    }
    
    // MARK: Collection
    public var startIndex: Set<DeviceType>.Index { return storage.startIndex }
    public var endIndex: Set<DeviceType>.Index { return storage.endIndex }
    
    public func index(after i: DeviceTypes.Index) -> DeviceTypes.Index {
        return storage.index(after: i)
    }
    
    public subscript(position: Set<DeviceType>.Index) -> DeviceType {
        return storage[position]
    }
}

// MARK: Predefined
public extension DeviceTypes {
    static let all: DeviceTypes = DeviceTypes(deviceTypes: [.android, .amazon, .ios, .web, .wns])
}

// MARK: Encodable
extension DeviceTypes: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        guard self != DeviceTypes.all else {
            return try container.encode("all")
        }
        
        try container.encode(Array(storage.map { $0.stringValue }))
    }
}

