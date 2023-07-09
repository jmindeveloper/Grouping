//
//  User.swift
//  Grouping
//
//  Created by J_Min on 2023/07/09.
//

import Foundation

enum Gender: String, Codable {
    case male, female
}

class User: Codable {
    let id: String
    var nickName: String
    var profileImagePath: String
    var birthDay: Date
    var phoneNumber: Int
    var gender: Gender
    var followersCount: Int
    var followingCount: Int
}
