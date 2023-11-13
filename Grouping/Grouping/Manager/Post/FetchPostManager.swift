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
    
    func getUserPosts(completion: (([Post]) -> Void)?)
    func getPosts(ids: [String], completion: (([Post]) -> Void)?)
}

final class FetchPostManager: FetchPostManagerInterface {
    private let postDB = Firestore.firestore().collection(FBFieldName.post)
    private let userPostDB: DocumentReference?
    
    let userPostsPublisher = CurrentValueSubject<[Post], Never>([])
    private var subscriptions = Set<AnyCancellable>()
    private var user: User?
    
    init(user: User) {
        self.user = user
        self.userPostDB = Firestore
            .firestore()
            .collection(FBFieldName.users)
            .document(user.id)
            .collection(FBFieldName.post)
            .document(FBFieldName.post)
    }
    
    init() {
        self.userPostDB = nil
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
    
    func getPosts(ids: [String], completion: (([Post]) -> Void)?) {
        let refs = ids.map {
            postDB.document($0)
        }
        
        refs.publisher
            .asyncMap { [weak self] ref in
                return await self?.getPost(ref: ref)
            }
            .collect()
            .map { posts in
                let posts = posts.compactMap { $0 }
                return posts.sorted { $0.createdAt > $1.createdAt }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] posts in
                completion?(posts)
                self?.userPostsPublisher.send(posts)
            }.store(in: &subscriptions)
    }
    
    private func getPost(ref: DocumentReference) async -> Post? {
        do {
            let post = try await ref.getDocument(as: Post.self)
            
            return post
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
