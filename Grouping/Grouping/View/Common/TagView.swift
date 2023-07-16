//
//  TagView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/16.
//

import SwiftUI

struct TagView: View {
    var tag: String
    var tapAction: (() -> Void)
    
    var body: some View {
        HStack(spacing: 0) {
            Text(tag)
                .foregroundColor(.primary)
                .font(.system(size: 17, weight: .semibold))
            
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 8, height: 8)
                .foregroundColor(.primary)
                .padding(.leading, 5)
        }
        .padding(.vertical, 3)
        .padding(.horizontal, 7)
        .background(Capsule().fill(Color(uc: .systemGreen)))
        .onTapGesture {
            tapAction()
        }
    }
}
