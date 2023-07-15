//
//  MainTabView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/15.
//

import SwiftUI

struct MainTabView: View {
    @State private var selection = 0 {
        didSet {
            print("beforeSelection --> ", oldValue)
        }
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ScrollView {
                ForEach(dummyPostData, id: \.self) { post in
                    PostView(post: post)
                        .padding(.vertical, 4)
                }
            }
            .tabItem {
                Image(systemName: "house")
            }
            .tag(0)
            
            Text("Map")
                .tabItem {
                    Image(systemName: "map")
                }
                .tag(1)
            
            SelectImageView()
                .tabItem {
                    Image(systemName: "plus.circle")
                }
                .tag(2)
            
            Text("Search")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(3)
            
            Text("Profile")
                .tabItem {
                    Image(systemName: "person")
                }
                .tag(4)
        }
        .accentColor(.primary)
        .onChange(of: selection) { index in
            if index == 2 {
                print("dkdkdkddkdkdk")
            }
        }
    }
}
