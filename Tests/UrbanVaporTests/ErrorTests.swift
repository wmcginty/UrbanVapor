//
//  ErrorTests.swift
//  Async
//
//  Created by William McGinty on 9/21/18.
//

import Foundation
import XCTest
@testable import UrbanVapor

class ErrorTests: XCTestCase {

    func test400Response() throws {
        let json = """
        {
            "ok" : false,
            "error" : "Could not parse request body.",
            "error_code" : 40000,
            "details" : {
                "error" : "The key 'alert1' is not allowed in this context",
                "path" : "notification.alert1",
                "location" : {
                    "line" : 5,
                    "column" : 18
                }
            }
        }
        """.data(using: .utf8)!
        
        let error = try JSONDecoder().decode(UrbanError.self, from: json)

        XCTAssertEqual(error.error, "Could not parse request body.")
        XCTAssertEqual(error.code, 40000)
        XCTAssertEqual(error.details?.message, "The key 'alert1' is not allowed in this context")
        XCTAssertEqual(error.details?.path, "notification.alert1")
        XCTAssertEqual(error.details?.location, UrbanError.Details.Location(line: 5, column: 18))
    }
    
    func test400ResponseWithoutLocation() throws {
        let json = """
        {
            "ok": false,
            "error": "Could not parse request body.",
            "error_code": 40902,
            "details": {
                "error": "sender can only contain digits"
            }
        }
        """.data(using: .utf8)!
        
        let error = try JSONDecoder().decode(UrbanError.self, from: json)
        
        XCTAssertEqual(error.error, "Could not parse request body.")
        XCTAssertEqual(error.code, 40902)
        XCTAssertEqual(error.details?.message, "sender can only contain digits")
        XCTAssertNil(error.details?.location)
    }
    
    func test404Response() throws {
        let json = """
        {
            "ok": false,
            "error": "Entity not found",
            "error_code": 40401
        }
        """.data(using: .utf8)!
        
        let error = try JSONDecoder().decode(UrbanError.self, from: json)
        
        XCTAssertEqual(error.error, "Entity not found")
        XCTAssertEqual(error.code, 40401)
        XCTAssertNil(error.details?.message)
    }
    
    func testAbortError() throws {
        let abortError = UrbanAbortError(status: .notFound, urbanError: UrbanError(error: "this is an error", code: 40400, details: nil))
        XCTAssertEqual(abortError.identifier, "40400")
        XCTAssertEqual(abortError.reason, "this is an error")
        XCTAssertEqual(abortError.status, .notFound)
        
        let abortError2 = UrbanAbortError(status: .notFound, urbanError: UrbanError(error: "this is an error", code: nil, details: UrbanError.Details(message: "detail message", path: nil, location: nil)))
        XCTAssertEqual(abortError2.identifier, "notFound")
        XCTAssertEqual(abortError2.reason, "this is an error- detail message")
        XCTAssertEqual(abortError2.status, .notFound)
    }
    
    func testNotConfiguredError() {
        let error = """
        {
            "ok":false,
            "error":"Could not parse request body.",
            "error_code":40000,
            "details":{
                "error":"No configured device_types could be resolved from request."
            }
        }
        """.data(using: .utf8)!
        
        let urbanError = try? JSONDecoder().decode(UrbanError.self, from: error)
        print(urbanError)
    }
    
    static var allTests: [(String, (ErrorTests) -> () throws -> Void)] = [
        ("test400Response", test400Response),
        ("test400ResponseWithoutLocation", test400ResponseWithoutLocation),
        ("test404Response", test404Response),
        ("testAbortError", testAbortError),
        ("testNotConfiguredError", testNotConfiguredError),
    ]
}
