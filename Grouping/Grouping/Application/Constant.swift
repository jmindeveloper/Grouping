//
//  Constant.swift
//  Grouping
//
//  Created by J_Min on 2023/07/09.
//

import UIKit

struct Constant {
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    static var rootVC: UIViewController? {
        UIApplication.shared.windows.first?.rootViewController
    }
}

struct FBFieldName {
    private init() { }
    
    // MARK: - Collection
    /// collection Users
    static var users: String {
        return "Users"
    }
    
    /// collection and document Post
    static var post: String {
        return "Post"
    }

    /// collection and document Post
    static var group: String {
        return "Group"
    }

    /// collection and document Post
    static var starPost: String {
        return "StarPost"
    }

    /// collection and document Post
    static var starGroup: String {
        return "StarGroup"
    }

    // MARK: - Documents
    
    
    // MARK: - Field
    /// field followers
    static var followers: String {
        return "followers"
    }
    
    /// field following
    static var following: String {
        return "following"
    }
    
    /// user posts
    static var userPosts: String {
        return "posts"
    }

    /// user groups
    static var userGroup: String {
        return "groups"
    }

    /// user startPosts
    static var userStarPost: String {
        return "starPosts"
    }

    /// user startGroups
    static var userStarGroup: String {
        return "starGroups"
    }
}
