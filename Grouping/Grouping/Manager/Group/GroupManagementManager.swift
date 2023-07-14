//
//  GroupManagementManager.swift
//  Grouping
//
//  Created by J_Min on 2023/07/14.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol GroupManagementManagerInterface {
    func create(name: String, description: String, thumbnailImage: Data?, completion: ((_ group: Group) -> Void)?)
    func update(group: Group, name: String?, description: String?, thumbnailImage: Data?, isThumbnailDelete: Bool, completion: ((_ group: Group) -> Void)?)
    func delete(group: Group, completion: ((_ isSuccess: Bool) -> Void)?)
}

class GroupManagementManager: GroupManagementManagerInterface {
    private let ref = Storage.storage().reference()
    private let userDB = Firestore.firestore().collection(FBFieldName.users)
    private let groupDB = Firestore.firestore().collection(FBFieldName.group)
    
    func create(
        name: String,
        description: String,
        thumbnailImage: Data?,
        completion: ((_ group: Group) -> Void)? = nil
    ) {
        guard let user = UserAuthManager.shared.user else {
            return
        }
        let groupId = UUID().uuidString
        uploadImage(id: groupId, image: thumbnailImage) { [weak self] urlString in
            guard let self = self else {
                return
            }
            let group = Group(
                groupId: groupId,
                groupName: name,
                groupDescription: description,
                groupThumbnailImageURL: urlString,
                posts: [],
                createUserId: user.id,
                managementUsers: [user.id],
                shareMembers: [user.id],
                startUsers: [],
                approvalWaitingUsers: []
            )
            
            do {
                try self.groupDB
                    .document(groupId)
                    .setData(from: group) { [weak self] error in
                        guard error == nil else {
                            print(error!.localizedDescription)
                            return
                        }
                        self?.userDB.document(user.id)
                            .collection(FBFieldName.group)
                            .document(FBFieldName.group)
                            .updateData([FBFieldName.userGroup: FieldValue.arrayUnion([groupId])]) { error in
                                guard error == nil else {
                                    print(error!.localizedDescription)
                                    return
                                }
                                completion?(group)
                            }
                        
                    }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func update(
        group: Group,
        name: String?,
        description: String?,
        thumbnailImage: Data?,
        isThumbnailDelete: Bool,
        completion: ((_ group: Group) -> Void)? = nil
    ) {
        guard let user = UserAuthManager.shared.user,
              user.id == group.createUserId else {
            return
        }
        
        if !isThumbnailDelete {
            uploadImage(id: group.groupId, image: thumbnailImage) { [weak self] urlString in
                guard let self = self else {
                    return
                }
                let group = Group(
                    groupId: group.groupId,
                    groupName: name ?? group.groupName,
                    groupDescription: description ?? group.groupDescription,
                    groupThumbnailImageURL: urlString,
                    posts: [],
                    createUserId: user.id,
                    managementUsers: [user.id],
                    shareMembers: [user.id],
                    startUsers: [],
                    approvalWaitingUsers: []
                )
                
                do {
                    try self.groupDB
                        .document(group.groupId)
                        .setData(from: group) { error in
                            guard error == nil else {
                                print(error!.localizedDescription)
                                return
                            }
                            completion?(group)
                        }
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            let group = Group(
                groupId: group.groupId,
                groupName: name ?? group.groupName,
                groupDescription: description ?? group.groupDescription,
                groupThumbnailImageURL: nil,
                posts: [],
                createUserId: user.id,
                managementUsers: [user.id],
                shareMembers: [user.id],
                startUsers: [],
                approvalWaitingUsers: []
            )
            do {
                try self.groupDB
                    .document(group.groupId)
                    .setData(from: group) { error in
                        guard error == nil else {
                            print(error!.localizedDescription)
                            return
                        }
                        completion?(group)
                    }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func delete(group: Group, completion: ((_ isSuccess: Bool) -> Void)? = nil) {
        guard let user = UserAuthManager.shared.user,
              user.id == group.createUserId else {
            return
        }
        
        groupDB
            .document(group.groupId)
            .delete { [weak self] error in
                guard let self = self else { return }
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                self.userDB.document(user.id)
                    .collection(FBFieldName.group)
                    .document(FBFieldName.group)
                    .updateData([FBFieldName.userGroup: FieldValue.arrayRemove([group.groupId])]) { error in
                        guard error == nil else {
                            print(error!.localizedDescription)
                            return
                        }
                        completion?(true)
                    }
            }
    }
    
    private func uploadImage(
        id: String,
        image: Data?,
        completion: ((_ urlString: String?) -> Void)? = nil
    ) {
        guard let data = image else {
            completion?(nil)
            return
        }
        
        let ref = ref.child("Group/\(id)/thumbnails/\(UUID().uuidString).jpg")
        ref.putData(data) { meta, error in
            ref.downloadURL { url, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                guard let url = url else {
                    return
                }
                completion?(url.absoluteString)
            }
        }
    }
}
