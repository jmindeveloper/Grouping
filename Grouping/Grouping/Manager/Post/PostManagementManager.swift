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
    func upload(completion: ((_ post: Post) -> Void)?)
    func update(completion: ((_ post: Post) -> Void)?)
    func delete(completion: ((_ isSuccess: Bool) -> Void)?)
    func createPost(images: [String], content: String, location: Location, tags: [String]) -> Post?
    func editPost(post: Post, images: [String]?, content: String?, location: Location?, tags: [String]?) -> Post?
}

final class PostManagementManager: PostManagementManagerInterface {
    private let ref = Storage.storage().reference()
    private let db = Firestore.firestore()
    
    func createPost(
        images: [String],
        content: String,
        location: Location,
        tags: [String]
    ) -> Post? {
        guard let user = UserAuthManager.shared.user else {
            return nil
        }
        
        return Post(
            id: UUID().uuidString,
            createUserId: user.id,
            images: images,
            content: content,
            createdAt: Date(),
            updatedAt: nil,
            location: location,
            heartCount: 0,
            heartUsers: [],
            commentCount: 0,
            tags: tags
        )
    }
    
    func editPost(
        post: Post,
        images: [String]?,
        content: String?,
        location: Location?,
        tags: [String]?
    ) -> Post? {
        guard let user = UserAuthManager.shared.user,
              user.id == post.createUserId else {
            return nil
        }
        
        return Post(
            id: post.id,
            createUserId: post.createUserId,
            images: images == nil ? post.images : images!,
            content: content == nil ? post.content : content!,
            createdAt: post.createdAt,
            updatedAt: Date(),
            location: location == nil ? post.location : location!,
            heartCount: post.heartCount,
            heartUsers: post.heartUsers,
            commentCount: post.commentCount,
            tags: tags == nil ? post.tags : tags!
        )
    }
    
    func upload(completion: ((_ post: Post) -> Void)? = nil) {
        
    }
    
    func update(completion: ((_ post: Post) -> Void)? = nil) {
        
    }
    
    func delete(completion: ((_ isSuccess: Bool) -> Void)? = nil) {
        
    }
    
    func uploadImages(
        images: [Data],
        uploadDoneCount: ((_ totalCount: Int, _ doneCount: Int) -> Void)? = nil,
        completion: ((_ urlStrings: [String]) -> Void)? = nil
    ) {
        guard let user = UserAuthManager.shared.user else {
            return
        }
        var doneCount = 0
        var urlStrings: [String] = []
        
        let ref = ref.child("Users/\(user.id)/post/images")
        for image in images {
            let ref = ref.child(UUID().uuidString + ".jpg")
            ref.putData(image) { meta, error in
                doneCount += 1
                let uploadFinish = doneCount == images.count
                guard error == nil else {
                    print(error!.localizedDescription)
                    uploadDoneCount?(images.count, doneCount)
                    if uploadFinish {
                        completion?(urlStrings)
                    }
                    return
                }
                
                ref.downloadURL { url, error in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        uploadDoneCount?(images.count, doneCount)
                        if uploadFinish {
                            completion?(urlStrings)
                        }
                        return
                    }
                    guard let url = url else {
                        uploadDoneCount?(images.count, doneCount)
                        if uploadFinish {
                            completion?(urlStrings)
                        }
                        return
                    }
                    urlStrings.append(url.absoluteString)
                    uploadDoneCount?(images.count, doneCount)
                    if uploadFinish {
                        completion?(urlStrings)
                    }
                }
            }
        }
    }
}

