//
//  Push.Audience.swift
//  App
//
//  Created by William McGinty on 5/7/18.
//

import Foundation

struct Audience: Encodable {
    
    private var audience: [String: String] = [:]
    
    init(dictionary: [String: String]) {
        audience = dictionary
    }
}

//MARK: Predefined
extension Audience {
    
    static func iOSChannelID(_ channel: String) -> Audience {
        return Audience(dictionary: ["ios_channel" : channel])
    }
    
    static func deviceToken(_ token: String) -> Audience {
        return Audience(dictionary: ["device_token" : token])
    }
    
    static func namedUser(_ user: String) -> Audience {
        return Audience(dictionary: ["named_user" : user])
    }
}
