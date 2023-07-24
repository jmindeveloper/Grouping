//
//  SearchManager.swift
//  Grouping
//
//  Created by J_Min on 2023/07/24.
//

import Foundation
import FirebaseFirestore

protocol SearchManagerInterface {
    func searchEqualField(collection: SearchManager.Collection, fieldName: String, keyword: String, completion: (([QueryDocumentSnapshot]) -> Void)?)
    func searchContainsField(collection: SearchManager.Collection, fieldName: String, keyword: String, completion: (([QueryDocumentSnapshot]) -> Void)?)
}

final class SearchManager: SearchManagerInterface {
    
    enum Collection {
        case User, Group, Tag
        
        var fieldName: String {
            switch self {
            case .User:
                return FBFieldName.users
            case .Group:
                return FBFieldName.group
            case .Tag:
                return FBFieldName.post
            }
        }
    }
    
    func searchEqualField(collection: Collection, fieldName: String, keyword: String, completion: (([QueryDocumentSnapshot]) -> Void)? = nil) {
        let query = Firestore.firestore()
            .collection(collection.fieldName)
            .whereField(fieldName, isEqualTo: keyword)
        
        query.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let snapshot = snapshot else {
                return
            }
            completion?(snapshot.documents)
        }
    }
    
    func searchContainsField(collection: Collection, fieldName: String, keyword: String, completion: (([QueryDocumentSnapshot]) -> Void)? = nil) {
        let query = Firestore.firestore()
            .collection(collection.fieldName)
            .whereField(fieldName, isGreaterThan: keyword)
            .whereField(fieldName, isLessThan: keyword + "\u{f8ff}")
        
        query.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let snapshot = snapshot else {
                return
            }
            completion?(snapshot.documents)
        }
    }
}
