//
//  PostManagementManager.swift
//  Grouping
//
//  Created by J_Min on 2023/07/13.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol PostManagementManagerInterface {
    func upload(images: [Data], content: String, location: Location?, tags: [String], groupId: String?, completion: ((_ post: Post) -> Void)?)
    func update(post: Post, content: String, location: Location?, tags: [String],  groupId: String?, completion: ((_ post: Post) -> Void)?)
    func delete(post: Post, completion: ((_ isSuccess: Bool) -> Void)?)
}

final class PostManagementManager: PostManagementManagerInterface {
    private let ref = Storage.storage().reference()
    private let userDB = Firestore.firestore().collection(FBFieldName.users)
    private let postDB = Firestore.firestore().collection(FBFieldName.post)
    
    func upload(
        images: [Data],
        content: String,
        location: Location?,
        tags: [String],
        groupId: String?,
        completion: ((_ post: Post) -> Void)? = nil
    ) {
        guard let user = UserAuthManager.shared.user else {
            return
        }
        let postId = UUID().uuidString
        
        uploadImages(id: postId, images: images) { totalCount, doneCount in
            print("uploadCount --> ", totalCount, doneCount)
        } completion: { urlStrings in
            let post =  Post(
                id: postId,
                createUserId: user.id,
                images: urlStrings,
                content: content,
                createdAt: Date(),
                updatedAt: nil,
                location: location,
                heartUsers: [],
                commentCount: 0,
                tags: tags,
                groupId: groupId
            )
            
            let urlString = "https://asia-northeast3-grouping-3944d.cloudfunctions.net/groupingApp/api/posts?createUserId=\(user.id)&postId=\(postId)"
            
            guard let url = URL(string: urlString) else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            guard let body = try? DateJsonEncoder().encode(post) else {
                return
            }
            
            request.httpBody = body
            request.application_json()
            
            URLSession.shared.dataTask(with: request) { data, response, err in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    DispatchQueue.main.async {
                        completion?(post)
                    }
                }
            }.resume()
        }
    }
    
    func update(
        post: Post,
        content: String,
        location: Location?,
        tags: [String],
        groupId: String?,
        completion: ((_ post: Post) -> Void)? = nil
    ) {
        guard let user = UserAuthManager.shared.user,
              user.id == post.createUserId else {
            return
        }
        
        let post = Post(
            id: post.id,
            createUserId: user.id,
            images: post.images,
            content: content,
            createdAt: post.createdAt,
            updatedAt: Date(),
            location: location,
            heartUsers: post.heartUsers,
            commentCount: post.commentCount,
            tags: tags,
            groupId: groupId ?? post.groupId
        )
        
        do {
            try self.postDB
                .document(post.id)
                .setData(from: post) { [weak self] error in
                    guard let self = self else { return }
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    completion?(post)
                }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(post: Post, completion: ((_ isSuccess: Bool) -> Void)? = nil) {
        guard let user = UserAuthManager.shared.user,
              user.id == post.createUserId else {
            return
        }
        
        postDB
            .document(post.id)
            .delete { [weak self] error in
                guard let self = self else { return }
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                self.userDB.document(user.id)
                    .collection(FBFieldName.post)
                    .document(FBFieldName.post)
                    .updateData([FBFieldName.userPosts: FieldValue.arrayRemove([post.id])]) { error in
                        guard error == nil else {
                            print(error!.localizedDescription)
                            return
                        }
                        completion?(true)
                    }
            }
    }
    
    private func uploadImages(
        id: String,
        images: [Data],
        uploadDoneCount: ((_ totalCount: Int, _ doneCount: Int) -> Void)? = nil,
        completion: ((_ urlStrings: [String]) -> Void)? = nil
    ) {
        guard let user = UserAuthManager.shared.user else {
            return
        }
        var doneCount = 0
        var urlStrings: [String] = []
        
        let ref = ref.child("Post/\(id)/images")
        for image in images {
            let ref = ref.child(UUID().uuidString + ".jpg")
            ref.putData(image) { meta, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    doneCount += 1
                    uploadDoneCount?(images.count, doneCount)
                    if doneCount == images.count {
                        completion?(urlStrings)
                    }
                    return
                }
                
                ref.downloadURL { url, error in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        doneCount += 1
                        uploadDoneCount?(images.count, doneCount)
                        if doneCount == images.count {
                            completion?(urlStrings)
                        }
                        return
                    }
                    guard let url = url else {
                        doneCount += 1
                        uploadDoneCount?(images.count, doneCount)
                        if doneCount == images.count {
                            completion?(urlStrings)
                        }
                        return
                    }
                    urlStrings.append(url.absoluteString)
                    doneCount += 1
                    uploadDoneCount?(images.count, doneCount)
                    if doneCount == images.count {
                        completion?(urlStrings)
                    }
                }
            }
        }
    }
}

