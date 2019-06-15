//
//  APNSTests.swift
//  UrbanVaporTests
//
//  Created by William McGinty on 9/20/18.
//

import Foundation
import XCTest
@testable import UrbanVapor

class APNSTests: XCTestCase {
    
    func testBasicAPNSDecode() throws {
        let pushData = SampleAPNS.full.data(using: .utf8)!
        let decoder = JSONDecoder.custom(dates: .airship)
        let notification = try decoder.decode(UrbanVapor.Notification.self, from: pushData)
        
        XCTAssertEqual(notification.ios.alert?.title, "Matt Cain Throws a Perfect Game")
        XCTAssertEqual(notification.ios.alert?.body, "Matt Cain stymies the Houston Astros for San Francisco's first perfect game in franchise history.")
        XCTAssertEqual(notification.ios.threadIdentifier, "sfGiants_news")
        XCTAssertEqual(notification.ios.mutableContent, 1)
    }
    
    static var allTests: [(String, (APNSTests) -> () throws -> Void)] = [
        ("testBasicAPNSDecode", testBasicAPNSDecode),
    ]
}
