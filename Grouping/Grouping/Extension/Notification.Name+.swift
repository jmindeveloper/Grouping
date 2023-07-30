//
//  Notification.Name+.swift
//  Grouping
//
//  Created by J_Min on 2023/07/16.
//

import Foundation

extension Notification.Name {
    static let userLogin = Notification.Name(rawValue: "USER_LOGIN")
    static let userUpdate = Notification.Name(rawValue: "USER_UPDATE")
    // MARK: - Post
    static let uploadPost = Notification.Name(rawValue: "POST_UPLOAD")
    static let deletePost = Notification.Name(rawValue: "POST_DELETE")
}
