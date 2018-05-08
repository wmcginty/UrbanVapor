//
//  Push.Audience.swift
//  App
//
//  Created by William McGinty on 5/7/18.
//

import Foundation

public struct Audience: Encodable {
    
    // MARK: Properties
    private var audience: [String: String] = [:]
    
    // MARK: Initializers
    init(dictionary: [String: String]) {
        audience = dictionary
    }
}

// MARK: Predefined
public extension Audience {
    
    // MARK: Channels
    static func iosChannel(_ channel: String) -> Audience {
        return Audience(dictionary: ["ios_channel": channel])
    }
    
    static func amazonChannel(_ channel: String) -> Audience {
        return Audience(dictionary: ["amazon_channel": channel])
    }
    
    static func androidChannel(_ channel: String) -> Audience {
        return Audience(dictionary: ["android_channel": channel])
    }
    
    static func webChannel(_ channel: String) -> Audience {
        return Audience(dictionary: ["channel": channel])
    }
    
    static func openChannel(_ channel: String) -> Audience {
        return Audience(dictionary: ["open_channel": channel])
    }
    
    // MARK: Devices
    static func deviceToken(_ token: String) -> Audience {
        return Audience(dictionary: ["device_token": token])
    }
    
    static func wnsDevice(_ token: String) -> Audience {
        return Audience(dictionary: ["wns": token])
    }
    
    // MARK: Segments and Tags
    static func segment(_ segment: String) -> Audience {
        return Audience(dictionary: ["segment": segment])
    }
    
    static func tag(_ tag: String, group: String? = nil) -> Audience {
        var dict = ["tag" : tag]
        group.map { dict["group"] = $0 }
        return Audience(dictionary: dict)
    }
    
    static func staticList(_ list: String) -> Audience {
        return Audience(dictionary: ["static_list": list])
    }
    
    // MARK: Named Users
    static func namedUser(_ user: String) -> Audience {
        return Audience(dictionary: ["named_user": user])
    }
}
