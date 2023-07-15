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
                        ScrollView {
                            LazyVGrid(columns: columns, alignment: .leading, spacing: 2, pinnedViews: .sectionFooters) {
                                ForEach(0..<viewModel.assets.count, id: \.self) { index in
                                    SelectedImage(asset: viewModel.assets[index])
                                        .select(index: viewModel.getSelectImageNumbers(index: index))
                                        .frame(width: (Constant.screenWidth - 4) / 3, height: (Constant.screenWidth - 4) / 3)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            viewModel.select(index: index)
                                        }
                                        .tag(index)
                                }
                            }
                        }
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
                    Text("최근 항목 ▾")
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
                
                Rectangle()
                    .fill(.red)
                    .frame(height: showAlbumCollection ? proxy.size.height - 34 + (Constant.safeAreaInsets?.bottom ?? 0) : 0)
            }
        }
    }
}

struct SelectImageView_Previews: PreviewProvider {
    static var previews: some View {
        SelectImageView(tabSelectionIndex: .constant(1), previousTab: 1, viewModel: SelectImageViewModel())
    }
}
