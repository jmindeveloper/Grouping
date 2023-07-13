//
//  Post.swift
//  Grouping
//
//  Created by J_Min on 2023/07/09.
//

import Foundation
import FirebaseFirestore

struct Location: Codable {
    /// 위도
    var latitude: CGFloat
    /// 경도
    var longitude: CGFloat
}

struct Post: Codable, Hashable {
    let id: String
    let createUserId: String
    let images: [String]
    let content: String
    let createdAt: Date
    var updatedAt: Date?
    var location: Location?
    var heartCount: Int
    var heartUsers: [String]
    var commentCount: Int
    var tags: [String]
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(createUserId)
    }
}

let dummyPostData: [Post] = [
    Post(
        id: UUID().uuidString,
        createUserId: "4721",
        images: ["test_image_1"],
        content: "안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요",
        createdAt: Date(),
        heartCount: 3,
        heartUsers: ["3939, 5322, 0532"],
        commentCount: 0,
        tags: [""]
    ),
    Post(
        id: UUID().uuidString,
        createUserId: "2356",
        images: ["test_image_2"],
        content: "안녕하세요은ㅇ라ㅣㅁㄴ;어라ㅣㄴ어라ㅣㅓㄴ아ㅣ;혼아ㅣ;멀;ㅏㅣㄴ어ㅣ;ㅁ런아ㅣㅓㅣㅏ처티프쿠프, ㅜㅁ;나ㅣ얼댜",
        createdAt: Date(),
        heartCount: 3,
        heartUsers: ["3939, 5322, 0532"],
        commentCount: 0,
        tags: [""]
    ),
    Post(
        id: UUID().uuidString,
        createUserId: "1438",
        images: ["test_image_3"],
        content: "안녕하세요3ㄷ2324356ㅁㄷㅇㄹㅎㅁ아ㅣ;ㅓ리'ㅏ;ㅁㄴ어라ㅣ",
        createdAt: Date(),
        heartCount: 3,
        heartUsers: ["3939, 5322, 0532"],
        commentCount: 0,
        tags: [""]
    ),
    Post(
        id: UUID().uuidString,
        createUserId: "34352",
        images: ["test_image_4"],
        content: "안녕하세요",
        createdAt: Date(),
        heartCount: 3,
        heartUsers: ["3939, 5322, 0532"],
        commentCount: 0,
        tags: [""]
    ),
    Post(
        id: UUID().uuidString,
        createUserId: "6533",
        images: ["test_image_5"],
        content: "안녕하세요",
        createdAt: Date(),
        heartCount: 3,
        heartUsers: ["3939, 5322, 0532"],
        commentCount: 0,
        tags: [""]
    ),
    Post(
        id: UUID().uuidString,
        createUserId: "254753",
        images: ["test_image_6"],
        content: "안녕하세요",
        createdAt: Date(),
        heartCount: 3,
        heartUsers: ["3939, 5322, 0532"],
        commentCount: 0,
        tags: [""]
    )
]
