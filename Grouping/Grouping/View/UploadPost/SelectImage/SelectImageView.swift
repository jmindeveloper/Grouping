//
//  SelectImageView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/15.
//

import SwiftUI

struct SelectImageView<VM>: View where VM: PostUploadViewModelInterface {
    @EnvironmentObject var viewModel: VM
    @Environment(\.presentationMode) var presentationMode
    var isTabPresent: Bool
    
    init(isTabPresent: Bool) {
        self.isTabPresent = isTabPresent
    }
    
    private var columns = Array(
        repeating: GridItem(
            .flexible(),
            spacing: 0
        ),
        count: 3
    )
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { proxy in
                    ZStack {
                        
                         LocalAlbumGridView(viewModel: viewModel)
                            .multiSelect(true)
                            .padding(.top, 37)
                        
                        VStack {
                            selectAlbumCollectionView()
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("업로드")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if isTabPresent {
                            MainTabView.changeSelection(MainTabView.previousTab)
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        PostContentWriteView<PostUploadViewModel>()
                    } label: {
                        Text("다음")
                            .foregroundColor(.primary)
                            .opacity(viewModel.selectedImageIndexes.isEmpty ? 0.6 : 1)
                    }
                    .disabled(viewModel.selectedImageIndexes.isEmpty)
                }
            }
        }
    }
    
    @State var showAlbumCollection: Bool = false
    
    @ViewBuilder
    private func selectAlbumCollectionView() -> some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                HStack {
                    Text("\(viewModel.currentCollectionTitle) ▾")
                        .padding(.leading, 16)
                        .frame(height: 34)
                        .onTapGesture {
                            print("show albumView")
                            withAnimation(.linear(duration: 0.2)) {
                                showAlbumCollection.toggle()
                            }
                        }
                    Spacer()
                }
                .background(Color(uiColor: .systemGray6).frame(height: 34))
                
                albumCollectionList()
                    .frame(height: showAlbumCollection ? 300 : 0)
            }
        }
    }
    
    @ViewBuilder
    private func albumCollectionList() -> some View {
        ScrollView {
            VStack {
                ForEach(0..<viewModel.collections.count, id: \.self) { index in
                    VStack {
                        Text("\(viewModel.collections[index].localizedTitle ?? "")")
                            .background(
                                Color.primary.colorInvert().frame(width: Constant.screenWidth)
                            )
                            .onTapGesture {
                                viewModel.selectCollection(index)
                                showAlbumCollection = false
                            }
                        Divider()
                    }
                }
            }
        }
        .background(Color.primary.colorInvert())
    }
}

struct SelectImageView_Previews: PreviewProvider {
    static var previews: some View {
        SelectImageView<PostUploadViewModel>(isTabPresent: false)
    }
}
