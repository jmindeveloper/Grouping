//
//  Post.swift
//  Grouping
//
//  Created by J_Min on 2023/07/09.
//

import SwiftUI

struct PostView: View {
    @State var showFullText: Bool = false
    
    var body: some View {
        VStack {
            postUserView()
                .padding(.horizontal, 16)
            
            // post image main
            Image("test_image")
                .resizable()
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
            
            Text("안녕하세요 이건 post 문구입니다ㅏ언ㄹ;ㅣㅁㄴ얼;ㅣㅏㄴ어리ㅏㄴ얼;ㅣㅏㅁ너ㅣ;ㅏㄴㅁ;ㅣ러님아러ㅣㅏㅇ널;ㅣㅏ먼이라ㅓㄴ이ㅏㅓ리;ㅇ나ㅓㄹ아이ㅏㄹ미;ㄴ어린ㅁ아ㅓ린ㅁ아ㅓ리ㅏㄴㅁ어ㅣㄴㅁ;리ㅓㅏㄴ어리;마넝리;ㅏㄴ얼")
                .multilineTextAlignment(.leading)
                .lineLimit(showFullText ? nil : 3)
                .padding(.horizontal, 16)
            
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
            
            Text("User 이름")
            
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
        VStack {
            ScrollView(showsIndicators: false) {
                PostView()
                PostView()
                PostView()
            }
        }
    }
}
