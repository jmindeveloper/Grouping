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
    
    init(tabSelectionIndex: Binding<Int>, previousTab: Int) {
        self._tabSelectionIndex = tabSelectionIndex
        self.previousTab = previousTab
    }
    
    var body: some View {
        NavigationView {
            Text("select image")
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
}

