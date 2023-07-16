//
//  SelectImageView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/15.
//

import SwiftUI

struct SelectImageView<VM>: View where VM: SelectImageViewModelInterface {
    @Binding var tabSelectionIndex: Int
    private var previousTab: Int
    @ObservedObject var viewModel: VM
    
    var columns = Array(
        repeating: GridItem(
            .flexible(),
            spacing: 0
        ),
        count: 3
    )
    
    init(tabSelectionIndex: Binding<Int>, previousTab: Int, viewModel: VM) {
        self._tabSelectionIndex = tabSelectionIndex
        self.previousTab = previousTab
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { proxy in
                    ZStack {
                        
                        albumGrid()
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
                        tabSelectionIndex = previousTab
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .hideTabBar()
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
                .background(Color(uc: .systemGray6).frame(height: 34))
                
                albumCollectionList()
                    .frame(height: showAlbumCollection ? 300 : 0)
            }
        }
    }
    
    @ViewBuilder
    private func albumGrid() -> some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 2, pinnedViews: .sectionFooters) {
                ForEach(viewModel.assets) { asset in
                    SelectedImage(asset: asset)
                        .select(index: viewModel.getSelectImageNumbers(asset: asset))
                        .frame(width: (Constant.screenWidth - 4) / 3, height: (Constant.screenWidth - 4) / 3)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.select(asset: asset)
                        }
                }
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
        SelectImageView(tabSelectionIndex: .constant(1), previousTab: 1, viewModel: SelectImageViewModel())
    }
}
