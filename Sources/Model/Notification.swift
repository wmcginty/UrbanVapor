//
//  Notification.swift
//  App
//
//  Created by William McGinty on 5/7/18.
//

import Foundation

public struct Notification: Encodable {
    
    // MARK: Properties
    let alert: String
    let title: String?
    let extra: [String: String]
    
    let ios: APNS?
}

// MARK: Subtypes
public extension Notification {
    
    // MARK: APNS
    public struct APNS: Encodable {
        
        // MARK: Properties
        let alert: String
        let title: String?
        let subtitle: String?
        
        let category: String
        let sound: String
        
        let priority: Priority?
        let badge: Badge?
        
        let collapseID: String?
        
        var contentAvailable: Bool?
        var mutableContent: Bool?
        
        var mediaAttachment: MediaAttachment?
        var extra: [String: String]?
        
        // MARK: Encodable
        private enum CodingKeys: String, CodingKey {
            case alert, title, subtitle, category, sound, priority, badge, extra
            case collapseID = "collapse_id"
            case contentAvailable = "content-available"
            case mutableContent = "mutable-content"
            case mediaAttachment = "media_attachment"
        }
    }
    
    // MARK: Badge
    public struct Badge: Encodable {
        
        // MARK: Properties
        private let stringValue: String
        
        // MARK: Initializers
        init(value: String) { stringValue = value }
        init(value: Int) { stringValue = "\(value)" }
        
        // MARK: Encodable
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(stringValue)
        }
        
        // MARK: Predefined
        public static let auto = Badge(value: "auto")
        public static func incrementBy(_ value: Int) -> Badge { return Badge(value: "+\(value)") }
        public static func decrementBy(_ value: Int) -> Badge { return Badge(value: "-\(value)") }
    }
    
    // MARK: Priority
    public enum Priority: Int, Encodable {
        case immediate = 10
        case nearFuture = 5
    }
    
    // MARK: MediaAttachment
    public struct MediaAttachment: Encodable {
        
        // MARK: Properties
        public let url: URL
        public let options: Options?
        public let content: Content?
        
        // MARK: Content
        public struct Content: Encodable {
            
            // MARK: Properties
            public let title: String
            public let subtitle: String
            public let body: String
        }
        
        // MARK: Options
        public struct Options: Encodable {
            
            // MARK: Properties
            public let crop: Crop
            public let time: Int?
            public let hidden: Bool?
            
            // MARK: Crop
            public struct Crop: Encodable {
                let x: Float
                let y: Float
                let width: Float
                let height: Float
            }
        }
    }
}
