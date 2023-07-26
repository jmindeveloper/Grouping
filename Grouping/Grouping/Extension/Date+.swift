//
//  Date+.swift
//  Grouping
//
//  Created by J_Min on 2023/07/26.
//

import Foundation

extension Date {
    func hoursDifference() -> (day: Int, hour: Int, min: Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .day], from: self, to: Date())
        
        return (components.day ?? 0, components.hour ?? 0, components.minute ?? 0)
    }
    
    func date2PostDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        formatter.locale = Locale(identifier: "ko_kr")
        
        return formatter.string(from: self)
    }
}
