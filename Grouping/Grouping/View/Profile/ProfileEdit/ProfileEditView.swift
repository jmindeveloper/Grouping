//
//  ProfileEditView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/19.
//

import SwiftUI

struct ProfileEditView: View {
    var body: some View {
        ScrollView {
            VStack {
                Image("test_image_5")
                    .resizable()
                    .frame(width: 160, height: 160)
                    .clipShape(Circle())
                    .padding(.top, 16)
                
                Text("김지민")
                    .font(.system(size: 31, weight: .semibold))
                    .padding(.top, 10)
                
                Divider()
            }
        }
        .navigationTitle("프로필 편집")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Text("완료")
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileEditView()
        }
    }
}
