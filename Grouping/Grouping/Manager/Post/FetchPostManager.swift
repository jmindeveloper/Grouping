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
    
    init(user: User) {
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
    
    private func getUserPostIds(completion: (([String]) -> Void)? = nil) {
        userPostDB?.getDocument { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let data = snapshot?.data() else {
                return
            }
            
            if let ids = data[FBFieldName.userPosts] as? [String] {
                completion?(ids)
            }
        }
    }
    
    func getUserPosts(completion: (([Post]) -> Void)? = nil) {
        getUserPostIds { [weak self] ids in
            guard let self = self else { return }
            let refs = ids.map {
                self.postDB.document($0)
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
