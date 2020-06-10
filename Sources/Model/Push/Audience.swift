//
//  Push.Audience.swift
//  App
//
//  Created by William McGinty on 5/7/18.
//

import Foundation

public struct Audience: Codable {
    
    // MARK: Properties
    private var audience: [String: AnyEncodable] = [:]
    
    // MARK: Initializers
    private init<T: Encodable>(_ dictionary: [String: T]) {
        audience = dictionary.mapValues(AnyEncodable.init)
    }
    
    private init<T: Encodable & Collection>(_ dictionary: [String: T]) where T.Element: Encodable {
        audience = dictionary.mapValues {
            guard let first = $0.first, $0.count == 1 else { return AnyEncodable($0) }
            return AnyEncodable(first)
        }
    }
    
    // MARK: Codable
    private struct CodingKeys: CodingKey {
        let stringValue: String
        init(stringValue: String) { self.stringValue = stringValue }
        
        var intValue: Int?
        init?(intValue: Int) { return nil }
    }
    
    public func encode(to encoder: Encoder) throws {
        try audience.encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dictionary = Dictionary<String, AnyEncodable>(uniqueKeysWithValues: try container.allKeys.map { key in
            if let singleValue = try? container.decode(String.self, forKey: key) {
                return (key.stringValue, AnyEncodable(singleValue))
            }
            
            let arrayOfValues = try container.decode([String].self, forKey: key)
            return (key.stringValue, AnyEncodable(arrayOfValues))
        })
        
        self.init(dictionary)
    }
}

// MARK: Predefined
public extension Audience {
    
    // MARK: Channels
    init(iosChannels channels: String...) {
        self.init(["ios_channel": channels])
    }
    
    init(amazonChannels channels: String...) {
        self.init(["amazon_channel": channels])
    }
    
    init(androidChannels channels: String...) {
        self.init(["android_channel": channels])
    }
    
    init(webChannels channels: String...) {
        self.init(["web_channel": channels])
    }

    init(openChannels channels: String...) {
        self.init(["open_channel": channels])
    }
    
    // MARK: Devices
    init(deviceToken token: String) {
        self.init(["device_token": token])
    }

    init(wnsDevice token: String) {
        self.init(["wns": token])
    }
    
    // MARK: Segments and Tags
    init(segmentID id: String) {
        self.init(["segment": id])
    }
    
    init(tag: String, group: String? = nil) {
        var dict = ["tag": tag]
        group.map { dict["group"] = $0 }
        self.init(dict)
    }
    
    init(staticList: String) {
        self.init(["static_list": staticList])
    }
    
    // MARK: Named Users
    init(namedUser user: String) {
        self.init(["named_user": user])
    }
}
