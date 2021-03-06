//
//  UrbanVaporTests.swift
//  UrbanVaporTests
//
//  Created by William McGinty on 5/13/18.
//

import Vapor
import XCTest
@testable import UrbanVapor

class UrbanVaporTests: XCTestCase {
    
    func testAppendingPathComponents() throws {
        let url = URL(string: "http://www.google.com")
        let new = url?.appendingPathComponents(["a","b","c"])
        XCTAssertEqual(new?.absoluteString, "http://www.google.com/a/b/c")
    }
    
    func testAddingAuthorizationHeaders() throws {
        let headers = HTTPHeaders()
        let added = headers.withAuthorization(forKey: "key", secret: "secret")
        XCTAssertTrue(added.contains(name: .authorization))
    }
    
    func testHTTPStatusIsSuccess() throws {
        XCTAssertTrue(HTTPStatus.ok.isSuccess)
        XCTAssertTrue(HTTPStatus.accepted.isSuccess)
        XCTAssertFalse(HTTPStatus.badGateway.isSuccess)
        XCTAssertTrue(HTTPStatus.created.isSuccess)
        XCTAssertTrue(HTTPStatus.noContent.isSuccess)
        XCTAssertFalse(HTTPStatus.internalServerError.isSuccess)
    }
    
    static var allTests: [(String, (UrbanVaporTests) -> () throws -> Void)] = [
        ("testAppendingPathComponents", testAppendingPathComponents),
        ("testAddingAuthorizationHeaders", testAddingAuthorizationHeaders),
        ("testHTTPStatusIsSuccess", testHTTPStatusIsSuccess)
    ]
}
