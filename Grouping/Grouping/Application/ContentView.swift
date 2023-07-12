//
//  ContentView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            ForEach(dummyPostData, id: \.self) { post in
                PostView(post: post)
                    .padding(.vertical, 4)
            }
        }
        .onAppear {
            UserAuthManager.shared.getUser(id: UserAuthManager.shared.getCurrentUserId ?? "") { isSuccess in
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
