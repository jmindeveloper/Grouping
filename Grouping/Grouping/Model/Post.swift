//
//  Post.swift
//  Grouping
//
//  Created by J_Min on 2023/07/09.
//

import Foundation
import FirebaseFirestore

struct Post: Codable, Hashable {
    let id: String
    let createUserId: String
    let images: [String]
    let content: String
    let createdAt: Date
    var location: CGFloat?
    var heartCount: Int
    var heartUsers: [String]
    var commentCount: Int
    var tags: [String]
}

let dummyPostData: [Post] = [
    Post(
        id: UUID().uuidString,
        createUserId: "4721",
        images: ["test_image"],
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
        images: ["test_image"],
        content: "안녕하세요",
        createdAt: Date(),
        heartCount: 3,
        heartUsers: ["3939, 5322, 0532"],
        commentCount: 0,
        tags: [""]
    ),
    Post(
        id: UUID().uuidString,
        createUserId: "1438",
        images: ["test_image"],
        content: "안녕하세요",
        createdAt: Date(),
        heartCount: 3,
        heartUsers: ["3939, 5322, 0532"],
        commentCount: 0,
        tags: [""]
    ),
    Post(
        id: UUID().uuidString,
        createUserId: "34352",
        images: ["test_image"],
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
        images: ["test_image"],
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
        images: ["test_image"],
        content: "안녕하세요",
        createdAt: Date(),
        heartCount: 3,
        heartUsers: ["3939, 5322, 0532"],
        commentCount: 0,
        tags: [""]
    )
]
