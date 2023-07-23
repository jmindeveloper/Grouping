//
//  FetchGroupManager.swift
//  Grouping
//
//  Created by J_Min on 2023/07/18.
//

import Foundation
import Combine
import FirebaseFirestore

protocol FetchGroupManagerInterface {
    init(user: User)
    
    func getUserGroups(completion: (([Group]) -> Void)?)
    func getGroup(completion: ((Group?) -> Void)?)
}

final class FetchGroupManager: FetchGroupManagerInterface {
    private let groupDB = Firestore.firestore().collection(FBFieldName.group)
    private let userGroupDB: DocumentReference?
    
    private let userGroupsPublisher = CurrentValueSubject<[Group], Never>([])
    private var subscriptions = Set<AnyCancellable>()
    private var groupId: String?
    
    init(user: User) {
        self.userGroupDB = Firestore
            .firestore()
            .collection(FBFieldName.users)
            .document(user.id)
            .collection(FBFieldName.group)
            .document(FBFieldName.group)
    }
    
    init?(groupId: String?) {
        if groupId == nil {
            return nil
        }
        self.groupId = groupId
        self.userGroupDB = nil
    }
    
    private func getUserGroupIds(completion: (([String]) -> Void)? = nil) {
        userGroupDB?.getDocument { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let data = snapshot?.data() else {
                return
            }
            
            if let ids = data[FBFieldName.userGroup] as? [String] {
                completion?(ids)
            }
        }
    }
    
    func getUserGroups(completion: (([Group]) -> Void)? = nil) {
        getUserGroupIds { [weak self] ids in
            guard let self = self else { return }
            let refs = ids.map {
                self.groupDB.document($0)
            }
            
            refs.publisher
                .asyncMap { [weak self] ref in
                    return await self?.getGroup(ref: ref)
                }
                .collect()
                .map { groups in
                    let groups = groups.compactMap { $0 }
                    return groups.sorted { $0.groupName < $1.groupName }
                }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] groups in
                    completion?(groups)
                    self?.userGroupsPublisher.send(groups)
                }.store(in: &subscriptions)
        }
    }
    
    func getGroup(completion: ((Group?) -> Void)?) {
        guard let groupId = groupId else {
            return
        }
        let ref = groupDB.document(groupId)
        
        Task {
            let group = await getGroup(ref: ref)
            DispatchQueue.main.async {
                completion?(group)
            }
        }
    }
    
    private func getGroup(ref: DocumentReference) async -> Group? {
        do {
            let post = try await ref.getDocument(as: Group.self)
            
            return post
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
