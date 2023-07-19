//
//  ValueChangeToggleView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/19.
//

import SwiftUI

struct ValueChangeToggleView: View {
    @Binding var toggle: Bool
    var lineColor: Color
    
    var leftTitle: String = ""
    var rightTitle: String = ""
    
    init(toggle: Binding<Bool>, lineColor: Color, leftTitle: String, rightTitle: String) {
        self._toggle = toggle
        self.lineColor = lineColor
        self.leftTitle = leftTitle
        self.rightTitle = rightTitle
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Capsule()
                    .fill(Color(uiColor: .systemGray2))
                
                HStack(spacing: 0) {
                    Text(leftTitle)
                        .foregroundColor(.white)
                        .font(.system(size: 21))
                        .frame(width: proxy.size.width / 2, height: proxy.size.height)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            toggle = true
                        }
                    
                    Text(rightTitle)
                        .foregroundColor(.white)
                        .font(.system(size: 21))
                        .frame(width: proxy.size.width / 2, height: proxy.size.height)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            toggle = false
                        }
                }
                
                HStack {
                    if !toggle {
                        Spacer()
                    }
                    
                    ValueChangeToggleViewHighlightedCapsule(lineColor: lineColor, toggle: $toggle, leftTitle: leftTitle, rightTitle: rightTitle)
                        .frame(width: proxy.size.width / 2, height: proxy.size.height)
                    
                    if toggle {
                        Spacer()
                    }
                }
                .animation(.easeIn(duration: 0.1), value: toggle)
            }
        }
    }
}

struct ValueChangeToggleViewHighlightedCapsule: View {
    @State var lineColor: Color
    @Binding var toggle: Bool
    var leftTitle: String
    var rightTitle: String
    
    var body: some View {
        ZStack {
            Capsule()
                .stroke(lineColor)
                .background(Capsule().fill(.white))
            
            Text(toggle ? leftTitle : rightTitle)
                .font(.system(size: 21))
                .foregroundColor(lineColor)
        }
    }
}
