//
//  Date.swift
//  Kaber
//
//  Created by Mohamed Ali on 17/08/2023.
//

import Foundation

extension Date {
    func hoursDifference() -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: self, to: currentDate)
        
        if let hours = components.hour {
            return hours
        }
        return 0 // Default value in case of an issue
    }
}
