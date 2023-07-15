//
//  MainTabView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/15.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ScrollView {
                ForEach(dummyPostData, id: \.self) { post in
                    PostView(post: post)
                        .padding(.vertical, 4)
                }
            }
            .tabItem {
                Image(systemName: "house")
            }
            
            Text("Map")
                .tabItem {
                    Image(systemName: "map")
                }
            
            Text("Upload")
                .tabItem {
                    Image(systemName: "plus.circle")
                }
            
            Text("Search")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            
            Text("Profile")
                .tabItem {
                    Image(systemName: "person")
                }
        }
        .accentColor(.primary)
    }
}
