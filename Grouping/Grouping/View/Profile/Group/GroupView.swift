//
//  GroupView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct GroupView<VM>: View where VM: GroupViewModelInterface {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: VM
    
    var gradientColor: [Color] {
        if colorScheme == .dark {
            return [.clear, .black]
        } else {
            return [.clear, .white]
        }
    }
    
    @State var imageScale: CGFloat = 1 {
        didSet {
            if imageScale < 1 {
                imageScale = 1
            }
        }
    }
    
    var body: some View {
        ZStack {
            
            ScrollOffsetView { offset in
                print(offset)
                imageScale = 1 + (offset / (Constant.screenWidth / 2))
            } content: {
                imageHeader()
                    .scaleEffect(CGSize(width: imageScale, height: imageScale))
                
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
            WebImage(url: URL(string: viewModel.group.groupThumbnailImageURL ?? ""))
                .resizable()
                .scaledToFill()
                .frame(maxWidth: Constant.screenWidth, minHeight: Constant.screenHeight / 2, maxHeight: Constant.screenHeight / 2)
                .clipShape(Rectangle())
                .background(Color.red)
                .overlay(
                    LinearGradient(colors: gradientColor, startPoint: .center, endPoint: .bottom)
                )
            
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(viewModel.group.groupName)
                            .lineLimit(2)
                            .font(.system(size: 50, weight: .bold))
                        
                        Text(viewModel.group.groupDescription)
                            .lineLimit(3)
                            .padding(.top)
                    }
                    .padding([.leading])
                    .padding(.bottom, 50)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Text("Members")
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.primary)
                    }
                    .padding(.bottom, 50)
                    .padding(.trailing)
                }
            }
        }
    }
}
