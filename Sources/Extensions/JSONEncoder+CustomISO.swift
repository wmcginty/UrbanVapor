//
//  JSONEncoder+CustomISO.swift
//  Async
//
//  Created by William McGinty on 5/13/18.
//

import Foundation

extension JSONEncoder.DateEncodingStrategy {
    
    private class CustomISO8601DateFormatter: DateFormatter {
        override init() {
            super.init()
            self.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        }
    }
    
    static let customISO8601 = JSONEncoder.DateEncodingStrategy.formatted(CustomISO8601DateFormatter())
}
