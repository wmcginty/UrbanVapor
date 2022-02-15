//
//  DeviceTypes.swift
//
//  Created by William McGinty on 5/7/18.
//

import Foundation

public enum DeviceType: Int, Codable, CaseIterable {
    case android = 1
    case amazon = 2
    case ios = 4
    case web = 8
    case wns = 16
    
    init?(stringValue: String) {
        switch stringValue {
        case DeviceType.android.stringValue: self = .android
        case DeviceType.amazon.stringValue: self = .amazon
        case DeviceType.ios.stringValue: self = .ios
        case DeviceType.web.stringValue: self = .web
        case DeviceType.wns.stringValue: self = .wns
        default: return nil
        }
    }
    
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
    public init(_ deviceTypes: DeviceType...) {
        storage = Set(deviceTypes)
    }
    
    public init(_ deviceTypes: [DeviceType]) {
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
    static let all: DeviceTypes = DeviceTypes(DeviceType.allCases)
    static let none: DeviceTypes = DeviceTypes([])
}

// MARK: Codable
extension DeviceTypes: Codable {
    
    private static let stringAll = "all"
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let singleType = try? container.decode(String.self) {
            if singleType == DeviceTypes.stringAll {
                self = .all; return
            }
        
            self = DeviceType(stringValue: singleType).map { DeviceTypes([$0]) } ?? .none
        }
        
        let typesList = try container.decode([String].self)
        self = DeviceTypes(typesList.compactMap { DeviceType(stringValue: $0) })
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        guard self != DeviceTypes.all else {
            return try container.encode(DeviceTypes.stringAll)
        }
        
        try container.encode(Array(storage.map { $0.stringValue }))
    }
}

