//
//  AudienceTests.swift
//  UrbanVaporTests
//
//  Created by William McGinty on 5/13/18.
//

import Vapor
import XCTest
@testable import UrbanVapor

class AudienceTests: XCTestCase {
    
    func testSegmentAudience() throws {
        let json = """
        {"audience":{"segment":"some_segment"}}
        """.data(using: .utf8)!
        
        let audience = Audience(segmentID: "some_segment")
        assertJSONEncoded(from: audience, matches: json)
    }
    
    func testTagAudience() throws {
        let json = """
        {"audience":{"tag":"fans"}}
        """.data(using: .utf8)!
        
        let audience = Audience(tag: "fans")
        let audience2 = Audience(tag: "fans", group: nil)
        assertJSONEncoded(from: audience, matches: json)
        assertJSONEncoded(from: audience2, matches: json)
    }
    
    func testGroupAudience() throws {
        let json = """
        {"audience":{"group":"platinum","tag":"fans"}}
        """.data(using: .utf8)!
        
        let audience = Audience(tag: "fans", group: "platinum")
        assertJSONEncoded(from: audience, matches: json)
    }
    
    func testSingleChannelAudience() {
        let json = """
        {"audience":{"ios_channel":"abcdefghijklmnopqrstuvwxyz"}}
        """.data(using: .utf8)!
        
        let audience = Audience(iosChannels: "abcdefghijklmnopqrstuvwxyz")
        assertJSONEncoded(from: audience, matches: json)
    }
    
    func testOpenChannelAudience() {
        let json = """
        {"audience":{"open_channel":"abcdefghijklmnopqrstuvwxyz"}}
        """.data(using: .utf8)!
        
        let audience = Audience(openChannels: "abcdefghijklmnopqrstuvwxyz")
        assertJSONEncoded(from: audience, matches: json)
    }
    
    func testWebChannelAudience() {
        let json = """
        {"audience":{"web_channel":"abcdefghijklmnopqrstuvwxyz"}}
        """.data(using: .utf8)!
        
        let audience = Audience(webChannels: "abcdefghijklmnopqrstuvwxyz")
        assertJSONEncoded(from: audience, matches: json)
    }

    func testMultiChannelAudience() {
        let json = """
        {"audience":{"amazon_channel":["user1","user2"]}}
        """.data(using: .utf8)!
        
        let audience = Audience(amazonChannels: "user1", "user2")
        assertJSONEncoded(from: audience, matches: json)
    }
    
    func testAndroidChannelAudience() {
        let json = """
        {"audience":{"android_channel":["user1","user2"]}}
        """.data(using: .utf8)!
        
        let audience = Audience(androidChannels: "user1", "user2")
        assertJSONEncoded(from: audience, matches: json)
    }

    func testDeviceTokenAudience() {
        let json = """
        {"audience":{"device_token":"abcdefghijklmnopqrstuvwxyz"}}
        """.data(using: .utf8)!
        
        let audience = Audience(deviceToken: "abcdefghijklmnopqrstuvwxyz")
        assertJSONEncoded(from: audience, matches: json)
    }
    
    func testWNSDeviceTokenAudience() {
        let json = """
        {"audience":{"wns":"abcdefghijklmnopqrstuvwxyz"}}
        """.data(using: .utf8)!
        
        let audience = Audience(wnsDevice: "abcdefghijklmnopqrstuvwxyz")
        assertJSONEncoded(from: audience, matches: json)
    }
    
    func testNamedUserAudience() {
        let json = """
        {"audience":{"named_user":"userid12345"}}
        """.data(using: .utf8)!
        
        let audience = Audience(namedUser: "userid12345")
        assertJSONEncoded(from: audience, matches: json)
    }
    
    func testStaticListAudience() {
        let json = """
        {"audience":{"static_list":"userid12345"}}
        """.data(using: .utf8)!
        
        let audience = Audience(staticList: "userid12345")
        assertJSONEncoded(from: audience, matches: json)
    }
    
    // MARK: Helper
    private func assertJSONEncoded<T: Encodable>(from element: T, matches data: Data, file: StaticString = #file, line: UInt = #line) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .airship
        let encoded = try! encoder.encode(element)
        
        XCTAssertEqual(encoded.count, data.count, file: file, line: line)
    }

    static var allTests: [(String, (AudienceTests) -> () throws -> Void)] = [
        ("testSegmentAudience", testSegmentAudience),
        ("testTagAudience", testTagAudience),
        ("testGroupAudience", testGroupAudience),
        ("testSingleChannelAudience", testSingleChannelAudience),
        ("testOpenChannelAudience", testOpenChannelAudience),
        ("testWebChannelAudience", testWebChannelAudience),
        ("testMultiChannelAudience", testMultiChannelAudience),
        ("testAndroidChannelAudience", testAndroidChannelAudience),
        ("testDeviceTokenAudience", testDeviceTokenAudience),
        ("testWNSDeviceTokenAudience", testWNSDeviceTokenAudience),
        ("testNamedUserAudience", testNamedUserAudience),
        ("testStaticListAudience", testStaticListAudience),
    ]
}
