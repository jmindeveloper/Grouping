//
//  ProfileEditView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/19.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileEditView<VM>: View where VM: ProfileEditViewModelInterface {
    @ObservedObject var viewModel: VM
    @State var showSelectImageView: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                if let data = viewModel.profileImageLocalData {
                    Image(uiImage: UIImage(data: data) ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 160)
                        .clipShape(Circle())
                        .padding(.top, 16)
                        .onTapGesture {
                            showSelectImageView.toggle()
                        }
                } else {
                    WebImage(url: URL(string: viewModel.user?.profileImagePath ?? ""))
                        .placeholder(Image(systemName: "person.fill").resizable())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 160)
                        .clipShape(Circle())
                        .padding(.top, 16)
                        .onTapGesture {
                            showSelectImageView.toggle()
                        }
                }
                
                TextField("", text: $viewModel.nickName)
                    .multilineTextAlignment(.center)
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
                    viewModel.update()
                } label: {
                    Text("완료")
                        .foregroundColor(.primary)
                }
            }
        }
        .fullScreenCover(isPresented: $showSelectImageView) {
            NavigationView {
                LocalAlbumGridView(viewModel: viewModel)
                    .navigationTitle("프로필 이미지 선택")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                showSelectImageView.toggle()
                                viewModel.profileImageLocalData = nil
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showSelectImageView.toggle()
                            } label: {
                                Text("완료")
                                    .foregroundColor(.primary)
                            }
                        }
                    }
            }
        }
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileEditView(viewModel: ProfileEditViewModel())
        }
    }
}
