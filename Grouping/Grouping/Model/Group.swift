//
//  Group.swift
//  Grouping
//
//  Created by J_Min on 2023/07/14.
//

import Foundation

struct Group: Codable {
    /// 그룹 id
    let groupId: String
    /// group name
    var groupName: String
    /// group 설명
    var groupDescription: String
    /// 그룹 썸네일 URL
    var groupThumbnailImageURL: String?
    /// 그룹에 포함된 Post 리스트
    var posts: [String]
    /// 그룹 만든사람
    var createUserId: String
    /// 그룹 관리하는 유저들
    var managementUsers: [String]
    /// 그룹에 가입된 사람들(createUser 포함)
    var shareMembers: [String]
    /// 그룹 좋아요 한 유저들
    var startUsers: [String]
    /// 승인 대기중인 유저들
    var approvalWaitingUsers: [String]
}
