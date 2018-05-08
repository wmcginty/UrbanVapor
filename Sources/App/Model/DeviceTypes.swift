//
//  DeviceTypes.swift
//  App
//
//  Created by William McGinty on 5/7/18.
//

import Foundation

struct DeviceTypes: Collection, Equatable {
    
    static let all: DeviceTypes = DeviceTypes(deviceTypes: [.android, .amazon, .ios, .web, .wns])

    // MARK: Properties
    private var storage: Set<DeviceType> = []
    
    // MARK: Initializer
    init(deviceTypes: [DeviceType]) {
        storage = Set(deviceTypes)
    }
    
    // MARK: Interface
    mutating func insert(_ deviceType: DeviceType) {
        storage.insert(deviceType)
    }
    
    // MARK: Collection
    var startIndex: Set<DeviceType>.Index { return storage.startIndex }
    var endIndex: Set<DeviceType>.Index { return storage.endIndex }
    
    func index(after i: DeviceTypes.Index) -> DeviceTypes.Index {
        return storage.index(after: i)
    }
    
    subscript(position: Set<DeviceType>.Index) -> DeviceType {
        return storage[position]
    }
}

extension DeviceTypes: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        guard self != DeviceTypes.all else {
            return try container.encode("all")
        }
        
        try container.encode(Array(storage.map { $0.stringValue }))
    }
}

enum DeviceType: Int, Codable {
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
