//
//  CreateGroupView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/17.
//

import SwiftUI

struct CreateGroupView<VM>: View where VM: CreateGroupViewModelInterface {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: VM
    @State var showAlbum: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    TextField("그룹 이름", text: $viewModel.groupName)
                        .padding(.top, 8)
                    
                    TextView(text: $viewModel.groupDescription, placeHolder: "그룹 설명")
                        .font(.systemFont(ofSize: 20))
                        .border(Color.primary, width: 1)
                        .frame(height: 300)
//                        .padding(.horizontal, 16)
                        .padding(.top, 6)
                    
                    Button {
                        showAlbum = true
                    } label: {
                        Text("이미지 선택")
                            .frame(width: Constant.screenWidth - 32, height: 56)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color(uc: .systemGray6)))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                
            }
            .navigationTitle("그룹 생성")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showAlbum) {
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.create(completion: nil)
                    } label: {
                        Text("생성")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView(viewModel: CreateGroupViewModel())
    }
}
