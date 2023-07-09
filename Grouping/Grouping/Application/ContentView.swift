//
//  ContentView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(dummyPostData, id: \.self) { post in
                    PostView(post: post)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
