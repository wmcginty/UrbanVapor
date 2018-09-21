//
//  UrbanError.swift
//  Async
//
//  Created by William McGinty on 9/21/18.
//

import Foundation
import Vapor

struct UrbanError: Swift.Error, Codable, Equatable {
    
    struct Details: Codable, Equatable {
        struct Location: Codable, Equatable {
            let line: Int
            let column: Int
        }
        
        let message: String?
        let path: String?
        let location: Location?
        
        // MARK: Codable
        private enum CodingKeys: String, CodingKey {
            case path, location
            case message = "error"
        }
    }
    
    let error: String
    let code: Int?
    let details: Details?
    
    // MARK: Codable
    private enum CodingKeys: String, CodingKey {
        case error, details
        case code = "error_code"
    }
}

struct UrbanAbortError: AbortError {
    
    // MARK: Properties
    let status: HTTPStatus
    let underlying: UrbanError
    
    // MARK: Initializers
    init(status: HTTPStatus, urbanError: UrbanError) {
        self.status = status
        self.underlying = urbanError
    }
    
    // MARK: AbortError
    var identifier: String { return underlying.code.map(String.init) ?? String(describing: status) }
    var reason: String {
        let detailMessage = underlying.details.map { return $0.message.map { "- \($0)" } ?? "" } ?? ""
        return [underlying.error, detailMessage].joined()
    }
}
