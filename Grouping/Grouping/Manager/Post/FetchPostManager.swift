//
//  FetchPostManager.swift
//  Grouping
//
//  Created by J_Min on 2023/07/16.
//

import Foundation
import Combine
import FirebaseFirestore

protocol FetchPostManagerInterface {
    init(user: User)
    init(group: Group)
    
    func getUserPosts(completion: (([Post]) -> Void)?)
    func getGroupPosts(completion: (([Post]) -> Void)?)
}

final class FetchPostManager: FetchPostManagerInterface {
    private var subscriptions = Set<AnyCancellable>()
    private var user: User?
    private var group: Group?
    
    init(user: User) {
        self.user = user
    }
    
    init(group: Group) {
        self.group = group
    }
    
    func getUserPosts(completion: (([Post]) -> Void)? = nil) {
        guard let user = user else {
            return
        }
        let urlString = "https://asia-northeast3-grouping-3944d.cloudfunctions.net/groupingApp/api/users/posts?userId=\(user.id)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                guard let data = data else {
                    return
                }
                
                do {
                    let posts = try DateJsonDecoder().decode([Post].self, from: data)
                    completion?(posts)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func getGroupPosts(completion: (([Post]) -> Void)?) {
        guard let group = group else {
            return
        }
        let urlString = "https://asia-northeast3-grouping-3944d.cloudfunctions.net/groupingApp/api/groups/posts?groupId=\(group.id)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                guard let data = data else {
                    return
                }
                
                do {
                    let posts = try DateJsonDecoder().decode([Post].self, from: data)
                    completion?(posts)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}
