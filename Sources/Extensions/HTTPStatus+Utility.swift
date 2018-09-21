//
//  HTTPStatus+Utility.swift
//  Async
//
//  Created by William McGinty on 9/21/18.
//

import Foundation
import Vapor

extension HTTPStatus {
    
    var isSuccess: Bool {
        return 200..<300 ~= code
    }
}
