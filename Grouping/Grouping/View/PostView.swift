//
//  PostView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/09.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostView: View {
    @State var showFullText: Bool = false
    @State var post: Post
    
    var body: some View {
        VStack {
            postUserView()
                .padding(.horizontal, 16)
            
            // post image main
            TabView {
                ForEach(post.images, id: \.self) { url in
                    WebImage(url: URL(string: url))
                        .placeholder(Image(url).resizable())
                        .resizable()
                        .scaledToFill()
                        .frame(width: Constant.screenWidth, height: Constant.screenWidth * 1.1)
                        .clipped()
                }
            }
            .tabViewStyle(.page)
            .frame(width: Constant.screenWidth, height: Constant.screenWidth * 1.1)
            .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
            .shadow(radius: 5, x: 0, y: 5)
            .onTapGesture(count: 2) {
                print("doubleTap!!!")
            }
            
            postInteractionView()
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .padding(.bottom, 2)
            
            if !post.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(post.tags, id: \.self) { tag in
                            TagView(tag: tag, showXMark: false) {
                                print("태그 검색 이동!!!!!!!!!")
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            
            HStack {
                Text(post.content)
                    .multilineTextAlignment(.leading)
                    .lineLimit(showFullText ? nil : 3)
                    .padding(.horizontal, 16)
                
                Spacer()
            }
            
            HStack {
                
                if !showFullText {
                    Button {
                        withAnimation(.linear(duration: 0.05)) {
                            showFullText = true
                        }
                    } label: {
                        Text("더보기...")
                            .foregroundColor(Color.gray)
                    }
                }
                
                Spacer()
                
                Text("5시간 전")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.top, 3)
        }
    }
    
    @ViewBuilder
    private func postUserView() -> some View {
        HStack {
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
                .onTapGesture {
                    
                }
            
            Text(post.createUserId)
            
            Spacer()
            
            Image(systemName: "ellipsis")
                .onTapGesture {
                    
                }
        }
    }
    
    @ViewBuilder
    private func postInteractionView() -> some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "bubble.right")
                    .resizable()
                    .foregroundColor(Color.primary)
            }
            .frame(width: 20, height: 20)
            
            Spacer()
            
            HStack(spacing: 12) {
                Button {
                    
                } label: {
                    Image(systemName: "heart")
                        .resizable()
                        .foregroundColor(.red)
                }
                .frame(width: 20, height: 20)
                
                Button {
                    
                } label: {
                    Image(systemName: "bookmark")
                        .resizable()
                        .foregroundColor(.yellow)
                }
                .frame(width: 20, height: 20)
                
                Button {
                    
                } label: {
                    Image(systemName: "paperplane")
                        .resizable()
                        .foregroundColor(.blue)
                }
                .frame(width: 20, height: 20)
            }
        }
    }
}

struct PostView_Preview: PreviewProvider {
    static var previews: some View {
        PostView(post: dummyPostData.first!)
    }
}
