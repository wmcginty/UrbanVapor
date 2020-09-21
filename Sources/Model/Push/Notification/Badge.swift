//
//  Badge.swift
//  Async
//
//  Created by William McGinty on 9/19/18.
//

import Foundation

// MARK: Badge
public struct Badge: Codable {
    
    // MARK: Properties
    private let stringValue: String
    
    // MARK: Initializers
    private init(value: String) { stringValue = value }
    init(value: Int) { stringValue = "\(value)" }
    
    // MARK: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(value: try container.decode(String.self))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(stringValue)
    }
    
    // MARK: Predefined
    public static let auto = Badge(value: "auto")
    public static func incrementBy(_ value: Int) -> Badge { return Badge(value: "+\(value)") }
    public static func decrementBy(_ value: Int) -> Badge { return Badge(value: "-\(value)") }
}
