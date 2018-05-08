//
//  DeviceTypesTests.swift
//  App
//
//  Created by William McGinty on 5/7/18.
//

import Foundation
import XCTest

final class DeviceTypeTests  : XCTestCase {
    
    func testAllTypes() throws {
        let deviceTypes = DeviceTypes.all
        let encoded = try! JSONEncoder().encode(deviceTypes)
        
    }
    
    func testNothing() throws {
        XCTAssert(true)
    }
    
    static let allTests = [
        ("testNothing", testNothing),
        ]
}
