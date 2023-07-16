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
        VStack {
            TextView(text: $contentText, placeHolder: "입력.....")
                .font(.systemFont(ofSize: 20))
                .frame(height: 300)
                .border(Color.primary, width: 1)
                .padding(.horizontal, 15)
            
            Spacer()
        }
    }
}

struct PostContentWriteView_Previews: PreviewProvider {
    static var previews: some View {
        PostContentWriteView()
    }
}
