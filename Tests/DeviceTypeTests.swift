//
//  DeviceTypeTests.swift
//  UrbanVaporTests
//
//  Created by William McGinty on 5/13/18.
//

import Vapor
import XCTest
@testable import UrbanVapor

class DeviceTypeTests: XCTestCase {
    
    private struct DeviceTypeContainer: Codable{
        let types: DeviceTypes
    }
    
    func testSingleDeviceType() throws {
        let json = "[\"ios\"]".data(using: .utf8)!
        let type = DeviceTypes(.ios)
        assertJSONEncoded(from: type, matches: json)
    }
    
    func testAllDeviceType() throws {
        let json = """
        {"types":"all"}
        """.data(using: .utf8)!
      
        let type = DeviceTypes.all
        let container = DeviceTypeContainer(types: type)
        assertJSONEncoded(from: container, matches: json)
    }
    
    func testDecodingAllDeviceType() throws {
        let json = """
        {"types":"all"}
        """.data(using: .utf8)!
        let decodedTypes = try? JSONDecoder().decode(DeviceTypeContainer.self, from: json).types
        
        XCTAssertEqual(decodedTypes, .all)
    }
    
    func testDeviceTypeList() throws {
        let json = "[\"ios\",\"android\",\"amazon\"]".data(using: .utf8)!
        let decodedTypes = try? JSONDecoder().decode(DeviceTypes.self, from: json)
        
        let types = DeviceTypes(.ios, .android, .amazon)
        assertJSONEncoded(from: types, matches: json)
        
        XCTAssertEqual(decodedTypes, types)
    }
    
    func testDeviceTypeInsert() throws {
        var types = DeviceTypes(.ios)
        XCTAssertTrue(types.contains(.ios))
        XCTAssertEqual(types.count, 1)
        
        types.insert(.ios)
        XCTAssertEqual(types.count, 1)
        
        types.insert(.android)
        XCTAssertTrue(types.contains(.android))
        XCTAssertEqual(types.count, 2)
    }

    // MARK: Helper
    private func assertJSONEncoded<T: Encodable>(from element: T, matches data: Data, file: StaticString = #file, line: UInt = #line) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .airship
        let encoded = try! encoder.encode(element)
        
        XCTAssertEqual(encoded.count, data.count, file: file, line: line)
    }
    
    static var allTests: [(String, (DeviceTypeTests) -> () throws -> Void)] = [
        ("testSingleDeviceType", testSingleDeviceType),
        ("testAllDeviceType", testAllDeviceType),
        ("testDecodingAllDeviceType", testDecodingAllDeviceType),
        ("testDeviceTypeList", testDeviceTypeList),
    ]
}
