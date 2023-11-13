//
//  DateJsonEncoder.swift
//  Grouping
//
//  Created by J_Min on 11/13/23.
//

import Foundation

class DateJsonEncoder: JSONEncoder {
    override init() {
        super.init()
        dateEncodingStrategy = .iso8601
    }
}
