//
//  SelectImageView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/15.
//

import SwiftUI

struct SelectImageView: View {
    @Binding var tabSelectionIndex: Int
    private var previousTab: Int
    
    var columns = Array(
        repeating: GridItem(
            .flexible(),
            spacing: 0
        ),
        count: 3
    )
    
    init(tabSelectionIndex: Binding<Int>, previousTab: Int) {
        self._tabSelectionIndex = tabSelectionIndex
        self.previousTab = previousTab
    }
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 2, pinnedViews: .sectionFooters) {
                    ForEach(1..<7, id: \.self) { index in
                        SelectedImage(imageName: "test_image_\(index)")
                            .frame(width: (Constant.screenWidth - 4) / 3, height: (Constant.screenWidth - 4) / 3)
                            .clipped()
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
        SelectImageView(tabSelectionIndex: .constant(1), previousTab: 1)
    }
}
