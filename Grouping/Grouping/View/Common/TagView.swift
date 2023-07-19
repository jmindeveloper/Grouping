//
//  TagView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/16.
//

import SwiftUI

struct TagView: View {
    var tag: String
    var showXMark: Bool = true
    var tapAction: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 0) {
            Text(tag)
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .semibold))
            
            if showXMark {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.white)
                    .padding(.leading, 5)
            }
        }
        .padding(.vertical, 3)
        .padding(.horizontal, 7)
        .background(Capsule().fill(Color(uiColor: .systemGreen)))
        .onTapGesture {
            tapAction?()
        }
    }
}
