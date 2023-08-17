//
//  Date.swift
//  Kaber
//
//  Created by Mohamed Ali on 17/08/2023.
//

import Foundation

extension String {
    
    func dateFromString() -> Date {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from:self)!
        
        return date
    }
}
