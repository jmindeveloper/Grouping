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
            
            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 2, pinnedViews: .sectionFooters) {
                    ForEach(0..<viewModel.images.count, id: \.self) { index in
                        SelectedImage(imageName: viewModel.images[index])
                            .select(index: viewModel.getSelectImageNumbers(index: index))
                            .frame(width: (Constant.screenWidth - 4) / 3, height: (Constant.screenWidth - 4) / 3)
                            .onTapGesture {
                                viewModel.select(index: index)
                            }
                            .clipped()
                            .tag(index)
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

            
//            Text("select image")
        }
        .hideTabBar()
    }
}

struct SelectImageView_Previews: PreviewProvider {
    static var previews: some View {
        SelectImageView(tabSelectionIndex: .constant(1), previousTab: 1, viewModel: SelectImageViewModel())
    }
}
