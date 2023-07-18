//
//  ProfileGroupView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/17.
//

import SwiftUI

struct ProfileGroupView: View {
    @State var createGroup: Bool = false
    
    var body: some View {
        Text("Group")
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
    }
}
