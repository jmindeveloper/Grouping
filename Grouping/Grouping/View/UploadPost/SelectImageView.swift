//
//  SelectImageView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/15.
//

import SwiftUI

struct SelectImageView: View {
    @Environment(\.presentationMode) private var dissmiss
    
    var body: some View {
        NavigationView {
            Text("select image")
                .navigationTitle("업로드")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dissmiss.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.primary)
                        }
                    }
                }
        }
        .onAppear {
            
        }
    }
}

