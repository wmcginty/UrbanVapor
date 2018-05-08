//
//  Push.swift
//  App
//
//  Created by William McGinty on 5/7/18.
//

import Foundation

public struct Push: Encodable {
    
    public let audience: Audience
    public let notification: Notification
    public let deviceTypes: DeviceTypes
    
    //MARK: Codable
    private enum CodingKeys: String, CodingKey {
        case audience
        case notification
        case deviceTypes = "device_types"
    }
}
