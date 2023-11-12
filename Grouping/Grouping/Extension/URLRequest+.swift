//
//  URLRequest+.swift
//  Grouping
//
//  Created by J_Min on 11/12/23.
//

import Foundation

extension URLRequest {
    mutating func application_json() {
        addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}
