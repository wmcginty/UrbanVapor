//
//  HTTPHeaders+BasicAuth.swift
//
//  Created by William McGinty on 5/7/18.
//

import Foundation
import Vapor

extension HTTPHeaders {
    
    func withAuthorization(forKey key: String, secret: String) -> HTTPHeaders {
        var headers = self
        let userPass = Data("\(key):\(secret)".utf8).base64EncodedString()
        headers.add(name: .authorization, value: "Basic \(userPass)")
        
        return headers
    }
}
