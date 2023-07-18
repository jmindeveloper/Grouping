//
//  PostContentWriteView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/16.
//

import SwiftUI

struct PostContentWriteView<VM>: View where VM: PostUploadViewModelInterface {
    @EnvironmentObject var viewModel: VM
    @State var tagFieldText: String = ""
    @State var showGroupSelectView: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                contentTextView()
                    .frame(height: 300)
                    .padding(.horizontal, 16)
                    .padding(.top, 6)
                
                selectGroupButton()
                    .padding(.top, 10)
                    .padding(.horizontal, 16)
                
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.tags, id: \.self) { tag in
                            TagView(tag: tag) {
                                viewModel.removeTag(tag)
                            }
                        }
                    }
                }
                
                appendTagView()
                    .padding(.horizontal, 16)
                
            }
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.upload()
                    } label: {
                        Text("업로드")
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $showGroupSelectView) {
                ProfileGroupView<ProfileViewModel> { group in
                    
                }
                .environmentObject(ProfileViewModel())
            }
        }
    }
    
    @ViewBuilder
    private func contentTextView() -> some View {
        ZStack {
            TextView(text: $viewModel.contentText, placeHolder: "입력.....")
                .font(.systemFont(ofSize: 20))
                .border(Color.primary, width: 1)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Text("\(viewModel.contentText.count)/500")
                }
                .padding(.trailing, 10)
            }
            .padding(.bottom, 10)
        }
    }
    
    @ViewBuilder
    private func selectGroupButton() -> some View {
        Button {
            showGroupSelectView = true
        } label: {
            Text("그룹선택")
                .foregroundColor(.primary)
                .frame(width: Constant.screenWidth - 32, height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.primary.opacity(0.1))
                )
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func appendTagView() -> some View {
        HStack {
            TextField("tag", text: $tagFieldText)
                .textFieldStyle(.roundedBorder)
            
            Button {
                viewModel.appendTag(tagFieldText)
                tagFieldText.removeAll()
            } label: {
                Text("저장")
                    .foregroundColor(.primary)
            }
        }
    }
}

struct PostContentWriteView_Previews: PreviewProvider {
    static var previews: some View {
        PostContentWriteView<PostUploadViewModel>()
            .environmentObject(PostUploadViewModel())
    }
}
