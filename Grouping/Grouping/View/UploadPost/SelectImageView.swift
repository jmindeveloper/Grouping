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
    
    var rows = Array(
        repeating: GridItem(
            .flexible()
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
                LazyVGrid(columns: rows) {
                    ForEach(1..<7, id: \.self) { index in
                        Image("test_image_\(index)")
                            .resizable()
                            .scaledToFill()
                            .frame(width: Constant.screenWidth / 3 - 2, height: Constant.screenWidth / 3 - 2)
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
