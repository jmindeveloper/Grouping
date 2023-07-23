//
//  GroupView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/23.
//

import SwiftUI

struct GroupView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var gradientColor: [Color] {
        if colorScheme == .dark {
            return [.clear, .black]
        } else {
            return [.clear, .white]
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                imageHeader()
                
                EmptyView()
                    .frame(height: 10000)
            }
            .ignoresSafeArea(edges: [.all])
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.primary)
                    }
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color(uiColor: .systemGray3)))
                    .shadow(radius: 5, x: 0, y: 5)
                    .contentShape(Rectangle())
                    
                    
                }
                .padding(.trailing, 18)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func imageHeader() -> some View {
        ZStack {
            Image("test_image_1")
                .resizable()
                .scaledToFill()
                .clipped()
                .overlay(
                    LinearGradient(colors: gradientColor, startPoint: .center, endPoint: .bottom)
                )
        }
        .frame(height: Constant.screenHeight / 2)
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView()
    }
}
