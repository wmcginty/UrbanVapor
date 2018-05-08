//
//  Push.swift
//  App
//
//  Created by William McGinty on 5/7/18.
//

import Foundation

struct Push: Encodable {
    
    let audience: Audience
    let notification: Notification
    let deviceTypes: DeviceTypes
    
    //MARK: Codable
    private enum CodingKeys: String, CodingKey {
        case audience
        case notification
        case deviceTypes = "device_types"
    }
}
