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
    
}

class GroupManagementManager: GroupManagementManagerInterface {
    private let ref = Storage.storage().reference()
    private let userDB = Firestore.firestore().collection(FBFieldName.users)
    private let postDB = Firestore.firestore().collection(FBFieldName.group)
}
