//
//  UrbanVaporService.swift
//  App
//
//  Created by William McGinty on 5/5/18.
//

import Foundation
import Vapor

public struct UrbanVaporService: Service {
    
    let airshipKey: String
    let airshipMasterSecret: String
    
    /// Create a new UrbanVapor provider
    public init(key: String, secret: String) {
        airshipKey = key
        airshipMasterSecret = secret
    }
}

public extension UrbanVaporService {
    
    func validatePush(on client: Client) throws -> Future<Response> {
        
        let push = Push(audience: Audience.deviceToken("C03631A92CDA96929035B3C28289BE2031209FD765038B659FD942385203045A"),
                        notification: Notification(alert: "Hi from UrbanVapor!"),
                        deviceTypes: DeviceTypes(deviceTypes: [.ios]))
//        let json = """
//        {
//            "audience" : {
//                "device_token" : "C03631A92CDA96929035B3C28289BE2031209FD765038B659FD942385203045A"
//            },
//            "notification": {
//              "alert": "Hi from UrbanVapor!",
//              "ios": {
//                 "extra": {
//                    "url": "http://www.urbanairship.com"
//                 }
//              }
//            },
//            "device_types": ["ios"]
//        }
//        """
        
        var headers = HTTPHeaders()
        let userPass = Data("\(airshipKey):\(airshipMasterSecret)".utf8).base64EncodedString()
        headers.add(name: .authorization, value: "Basic \(userPass)")
        
        return client.post(URL(string: "https://go.urbanairship.com/api/push")!, headers: headers) { req in
            req.http.body = HTTPBody(data: try JSONEncoder().encode(push))
        }
    }
}
