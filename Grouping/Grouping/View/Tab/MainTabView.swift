//
//  MainTabView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/15.
//

import SwiftUI

struct MainTabView: View {
    @State private var selection = 0
    @State private var previousTab: Int = 0
    
    var body: some View {
        TabView(selection: $selection) {
            ScrollView {
                ForEach(dummyPostData, id: \.self) { post in
                    PostView(post: post)
                        .padding(.vertical, 4)
                }
            }
            .onAppear {
                UITabBar.showTabBar(animated: true)
            }
            .tabItem {
                Image(systemName: "house")
            }
            .tag(0)
            
            Text("Map")
                .onAppear {
                    UITabBar.showTabBar(animated: true)
                }
                .tabItem {
                    Image(systemName: "map")
                }
                .tag(1)
            
            SelectImageView(tabSelectionIndex: $selection, previousTab: previousTab, viewModel: SelectImageViewModel())
                .tabItem {
                    Image(systemName: "plus.circle")
                }
                .tag(2)
            
            Text("Search")
                .onAppear {
                    UITabBar.showTabBar(animated: true)
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(3)
            
            Text("Profile")
                .onAppear {
                    UITabBar.showTabBar(animated: true)
                }
                .tabItem {
                    Image(systemName: "person")
                }
                .tag(4)
        }
        .accentColor(.primary)
        .onChange(of: selection) { index in
            if index != 2 {
                previousTab = index
            }
        }
    }
}
