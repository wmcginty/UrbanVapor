import Vapor
import XCTest
@testable import UrbanVapor

class UrbanVaporTests: XCTestCase {
    
    func testNothing() throws {
        XCTAssert(true)
    }
    
    static var allTests: [(String, (UrbanVaporTests) -> () throws -> Void)] = [
        ("testNothing", testNothing),
    ]
}
