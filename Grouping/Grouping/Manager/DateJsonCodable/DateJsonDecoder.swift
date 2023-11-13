//
//  DateJsonDecoder.swift
//  Grouping
//
//  Created by J_Min on 11/14/23.
//

import Foundation

class DateJsonDecoder: JSONDecoder {
    override init() {
        super.init()
        dateDecodingStrategy = .iso8601
    }
}



