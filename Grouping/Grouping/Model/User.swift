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
    var profileImagePath: String?
    var birthDay: Date?
    var phoneNumber: Int?
    var gender: Gender?
    var followers: [String]
    var following: [String]
    
    init(id: String, nickName: String, profileImagePath: String? = nil, birthDay: Date? = nil, phoneNumber: Int? = nil, gender: Gender? = nil, followers: [String] = [], following: [String] = []) {
        self.id = id
        self.nickName = nickName
        self.profileImagePath = profileImagePath
        self.birthDay = birthDay
        self.phoneNumber = phoneNumber
        self.gender = gender
        self.followers = followers
        self.following = following
    }
}
