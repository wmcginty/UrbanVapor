//
//  URL+Path.swift
//  Async
//
//  Created by William McGinty on 5/7/18.
//

import Foundation

extension URL {
    
    func appendingPathComponents(_ components: [String]) -> URL {
        return components.reduce(self) { $0.appendingPathComponent($1) }
    }
}
