//
//  Notification.swift
//
//  Created by William McGinty on 5/7/18.
//

import Foundation

public struct Notification: Codable {
    
    // MARK: Properties
    public let ios: APNS
    
    public init(apns: APNS) {
        ios = apns
    }
}
