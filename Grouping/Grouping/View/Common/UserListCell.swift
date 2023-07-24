//
//  UserListCell.swift
//  Grouping
//
//  Created by J_Min on 2023/07/24.
//

import SwiftUI
import SDWebImageSwiftUI

protocol UserListCellViewModelInterface: ObservableObject {
    var user: User { get set }
}

final class UserListCellViewModel: UserListCellViewModelInterface {
    private var fetchUserManager: FetchUserManagerInterface
    @Published var user: User
    
    init(user: User) {
        self.user = user
        fetchUserManager = FetchUserManager(userId: user.id)
    }
}

struct UserListCell<VM>: View where VM: UserListCellViewModelInterface {
    @ObservedObject var viewModel: VM
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: viewModel.user.profileImagePath ?? ""))
                .placeholder(Image(systemName: "person.fill").resizable())
                .resizable()
                .frame(width: 45, height: 45)
                .clipShape(Circle())
            
            Text(viewModel.user.nickName)
        }
    }
}

struct UserListCell_Previews: PreviewProvider {
    static var previews: some View {
        UserListCell(viewModel: UserListCellViewModel(user: User(id: "", nickName: "j_MIN_3894", email: "")))
    }
}
