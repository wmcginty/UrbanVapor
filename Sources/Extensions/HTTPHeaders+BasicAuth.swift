//
//  HTTPHeaders+BasicAuth.swift
//  Async
//
//  Created by William McGinty on 5/7/18.
//

import Foundation
import Vapor

extension HTTPHeaders {
    
    static func authorizationHeaders(withKey key: String, secret: String) -> HTTPHeaders {
        var headers = HTTPHeaders()
        let userPass = Data("\(key):\(secret)".utf8).base64EncodedString()
        headers.add(name: .authorization, value: "Basic \(userPass)")
        
        return headers
    }
}
