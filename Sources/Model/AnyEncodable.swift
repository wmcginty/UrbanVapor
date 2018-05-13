//
//  AnyEncodabe.swift
//  UrbanVaporTests
//
//  Created by William McGinty on 5/13/18.
//

import Foundation

struct AnyEncodable: Encodable {
    
    // MARK: Properties
    private let encodable: Encodable
    
    // MARK: Initializers
    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }
    
    // MARK: Encodable
    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
