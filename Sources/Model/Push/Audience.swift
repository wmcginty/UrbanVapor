//
//  Push.Audience.swift
//  App
//
//  Created by William McGinty on 5/7/18.
//

import Foundation

public struct Audience: Codable {
    
    // MARK: Properties
    private var audience: [String: [String]] = [:]
    
    // MARK: Initializers
    private init(dictionary: [String: [String]]) {
        audience = dictionary
    }

    // MARK: Codable
    private struct CodingKeys: CodingKey {
        let stringValue: String
        init(stringValue: String) { self.stringValue = stringValue }
        
        var intValue: Int?
        init?(intValue: Int) { return nil }
    }
    
    public func encode(to encoder: Encoder) throws {
        for (key, value) in audience {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            if let first = value.first, value.count == 1 {
                try container.encode(first, forKey: CodingKeys(stringValue: key))
            } else {
                try container.encode(value, forKey: CodingKeys(stringValue: key))
            }
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dictionary = Dictionary<String, [String]>(uniqueKeysWithValues: try container.allKeys.map { key in
            if let singleValue = try? container.decode(String.self, forKey: key) {
                return (key.stringValue, [singleValue])
            }
            
            let arrayOfValues = try container.decode([String].self, forKey: key)
            return (key.stringValue, arrayOfValues)
        })
        
        self.init(dictionary: dictionary)
    }
}

// MARK: Predefined
public extension Audience {
    
    // MARK: Channels
    init(iosChannels channels: String...) {
        self.init(dictionary: ["ios_channel": channels])
    }
    
    init(amazonChannels channels: String...) {
        self.init(dictionary: ["amazon_channel": channels])
    }
    
    init(androidChannels channels: String...) {
        self.init(dictionary: ["android_channel": channels])
    }
    
    init(webChannels channels: String...) {
        self.init(dictionary: ["web_channel": channels])
    }

    init(openChannels channels: String...) {
        self.init(dictionary: ["open_channel": channels])
    }
    
    // MARK: Devices
    init(deviceToken token: String) {
        self.init(dictionary: ["device_token": [token]])
    }

    init(wnsDevice token: String) {
        self.init(dictionary: ["wns": [token]])
    }
    
    // MARK: Segments and Tags
    init(segmentID id: String) {
        self.init(dictionary: ["segment": [id]])
    }
    
    init(tag: String, group: String? = nil) {
        var dict = ["tag": [tag]]
        group.map { dict["group"] = [$0] }
        self.init(dictionary: dict)
    }
    
    init(staticList: String) {
        self.init(dictionary: ["static_list": [staticList]])
    }
    
    // MARK: Named Users
    init(namedUser user: String) {
        self.init(dictionary: ["named_user": [user]])
    }
}
