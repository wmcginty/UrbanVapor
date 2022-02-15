//
//  APNS.swift
//
//  Created by William McGinty on 9/19/18.
//

import Foundation

public struct APNS: Codable {
    
    /* Urban Airship APNS Documentation:
        https://docs.urbanairship.com/api/ua/#schemas%2fiosoverrideobject
     */

    public struct Alert: Codable {
        let title: String
        let subtitle: String?
        let body: String?
        let summaryArgument: String?
        let summaryArgumentCount: Int?
        
        public init(title: String, subtitle: String? = nil, body: String? = nil, summaryArgument: String? = nil, summaryArgumentCount: Int? = nil) {
            self.title = title
            self.subtitle = subtitle
            self.body = body
            self.summaryArgument = summaryArgument
            self.summaryArgumentCount = summaryArgumentCount
        }
        
        private enum CodingKeys: String, CodingKey {
            case title, subtitle, body
            case summaryArgument = "summary-arg"
            case summaryArgumentCount = "summary-arg-count"
        }
    }
    
    // MARK: Properties
    public var alert: Alert?
    
    public var threadIdentifier: String?
    public var category: String?
    public var priority: Priority?
    
    public var badge: Badge?
    public var extra: [String: String]?
    
    public var contentAvailable: Int?
    public var mutableContent: Int?
    
    // MARK: Initializers
    public init(alert: APNS.Alert?, threadID: String? = nil, category: String? = nil, priority: Priority? = nil, badge: Badge? = nil, extra: [String: String]? = nil,
                contentAvailable: Bool? = nil, mutableContent: Bool? = nil) {
        self.alert = alert
        self.threadIdentifier = threadID
        self.category = category
        self.priority = priority
        self.badge = badge
        self.extra = extra
        self.contentAvailable = (contentAvailable ?? false) ? 1 : 0
        self.mutableContent = (mutableContent ?? false) ? 1 : 0
    }
    
    // MARK: Codable
    private enum CodingKeys: String, CodingKey {
        case alert, category, badge, extra, priority
        case threadIdentifier = "thread_id"
        case contentAvailable = "content_available"
        case mutableContent = "mutable_content"
    }
}

// MARK: Convenience
extension APNS {
    public init(alert: String? = nil, threadID: String? = nil, category: String? = nil, priority: Priority? = nil, badge: Badge? = nil, extra: [String: String]? = nil,
                contentAvailable: Bool? = nil, mutableContent: Bool? = nil) {
        self.init(alert: alert.map { APNS.Alert(title: $0) },  threadID: threadID, category: category, priority: priority, badge: badge, extra: extra,
                  contentAvailable: contentAvailable, mutableContent: mutableContent)
    }
}
