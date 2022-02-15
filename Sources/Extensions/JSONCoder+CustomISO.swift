//
//  JSONEncoder+CustomISO.swift
//
//  Created by William McGinty on 5/13/18.
//

import Foundation

private class AirshipDateFormatter: DateFormatter {
    override init() {
        super.init()
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    }
}

extension JSONEncoder.DateEncodingStrategy {
    static let airship = JSONEncoder.DateEncodingStrategy.formatted(AirshipDateFormatter())
}

extension JSONDecoder.DateDecodingStrategy {
    static let airship = JSONDecoder.DateDecodingStrategy.formatted(AirshipDateFormatter())
}
