//
//  ProfileGroupView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/17.
//

import SwiftUI

struct ProfileGroupView<VM>: View where VM: ProfileViewModelInterface {
    @State var createGroup: Bool = false
    @EnvironmentObject var viewModel: VM
    private var groupSelectAction: ((Group) -> Void)?
    
    init(groupSelectAction: ((Group) -> Void)? = nil) {
        self.groupSelectAction = groupSelectAction
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.groups, id: \.groupId) { group in
                    ProfileGroupCell(group: group)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 3)
                }
            }
        }
        .fullScreenCover(isPresented: $createGroup) {
            CreateGroupView(viewModel: CreateGroupViewModel())
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    createGroup = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            viewModel.getUserGroups()
        }
    }
}
