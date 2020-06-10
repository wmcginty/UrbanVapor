//
//  NamedUserAssociation.swift
//  Async
//
//  Created by William McGinty on 5/7/18.
//

import Foundation

public struct NamedUserAssocation: Codable {
    
    let channelID: String
    let deviceType: DeviceType?
    let namedUserID: String
    
    private enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case deviceType = "device_type"
        case namedUserID = "named_user_id"
    }
}
