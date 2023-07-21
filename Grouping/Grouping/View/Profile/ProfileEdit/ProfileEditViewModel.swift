//
//  ProfileEditViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/19.
//

import Foundation
import Combine
import Photos
import FirebaseStorage

protocol ProfileEditViewModelInterface: LocalAlbumInterface {
    var user: User? { get set }
    var nickName: String { get set }
    var profileImageLocalData: Data? { get set }
    
    func update()
    func selectProfileImage()
}

final class ProfileEditViewModel: LocalAlbumGridDefaultViewModel, ProfileEditViewModelInterface {
    
    @Published var profileImageLocalData: Data? = nil
    var user: User? {
        didSet {
            nickName = user?.nickName ?? ""
        }
    }
    @Published var nickName: String = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    override init() {
        super.init()
        user = UserAuthManager.shared.user
        nickName = user?.nickName ?? ""
        
        binding()
    }
    
    private func binding() {
        NotificationCenter.default.publisher(for: .userLogin)
            .sink { [weak self] _ in
                self?.user = UserAuthManager.shared.user
            }.store(in: &subscriptions)
    }
    
    func update() {
        guard let user = user else { return }
        
        uploadProfileImage { [weak self] url in
            guard let self = self else { return }
            user.nickName = nickName
            if url != nil {
                user.profileImagePath = url
            }
            UserAuthManager.shared.updateUser(user: user) { [weak self] in
                self?.user = UserAuthManager.shared.user
                self?.objectWillChange.send()
            }
        }
    }
    
    func selectProfileImage() {
        library.getImageData(with: selectedImageIndexes.map { $0.asset }) { [weak self] data in
            self?.profileImageLocalData = data.first
        }
    }
    
    private func uploadProfileImage(completion: ((_ url: String?) -> Void)? = nil) {
        guard let user = user else {
            return
        }
        guard let data = profileImageLocalData else {
            completion?(nil)
            return
        }
        
        let ref = Storage.storage().reference()
            .child("Users/\(user.id)/ProfileImage/\(UUID().uuidString).jpg")
        
        ref.putData(data) { meta, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    completion?(nil)
                    return
                }
                
                ref.downloadURL { url, error in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        completion?(nil)
                        return
                    }
                    completion?(url?.absoluteString)
                }
            }
    }
}
