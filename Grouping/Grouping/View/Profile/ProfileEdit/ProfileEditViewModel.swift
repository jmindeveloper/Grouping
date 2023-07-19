//
//  ProfileEditViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/19.
//

import Foundation
import Combine

protocol ProfileEditViewModelInterface: ObservableObject {
    var user: User? { get set }
    var nickName: String { get set }
    
    func update()
}

final class ProfileEditViewModel: ProfileEditViewModelInterface {
    var user: User? {
        didSet {
            nickName = user?.nickName ?? ""
        }
    }
    @Published var nickName: String = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
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
        user.nickName = nickName
        UserAuthManager.shared.updateUser(user: user) { [weak self] in
            self?.user = UserAuthManager.shared.user
            self?.objectWillChange.send()
        }
    }
}
