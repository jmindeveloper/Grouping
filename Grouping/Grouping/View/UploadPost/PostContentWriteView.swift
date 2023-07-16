//
//  PostContentWriteView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/16.
//

import SwiftUI

struct PostContentWriteView: View {
    @State var contentText: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                contentTextView()
                    .frame(height: 300)
                    .padding(.horizontal, 15)
                    .padding(.top, 6)
                
                selectGroupButton()
                    .padding(.top, 10)
                
                Spacer()
                
                TagView(tag: "일본여행") {
                    print("tap!!!")
                }
                
            }
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    
    @ViewBuilder
    private func contentTextView() -> some View {
        ZStack {
            TextView(text: $contentText, placeHolder: "입력.....")
                .font(.systemFont(ofSize: 20))
                .border(Color.primary, width: 1)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Text("\(contentText.count)/500")
                }
                .padding(.trailing, 10)
            }
            .padding(.bottom, 10)
        }
    }
    
    private func selectGroupButton() -> some View {
        Button {
            
        } label: {
            Text("그룹선택")
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
                .frame(width: Constant.screenWidth - 32, height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.primary.opacity(0.1))
                )
        }
        .buttonStyle(.plain)
    }
}

struct PostContentWriteView_Previews: PreviewProvider {
    static var previews: some View {
        PostContentWriteView()
    }
}
