//
//  MainTabView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/15.
//

import SwiftUI
import Combine

struct MainTabView: View {
    @State private var selection = 0
    @State private var subscriptions = Set<AnyCancellable>()
    
    static let tapSelectionChangePublisher = PassthroughSubject<Int, Never>()
    static var previousTab: Int = 0
    
    static func changeSelection(_ index: Int) {
        tapSelectionChangePublisher.send(index)
    }
    
    @StateObject private var currentUserProfileViewModel = ProfileViewModel()
    @StateObject private var postUploadViewModel = PostUploadViewModel()
    @StateObject private var postFeedViewModel = PostFeedViewModel()
    @StateObject private var searchViewModel = SearchViewModel()
    
    var body: some View {
        TabView(selection: $selection) {
            PostFeedView(viewModel: postFeedViewModel, scrollTag: "")
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
            
            SelectImageView<PostUploadViewModel>()
                .environmentObject(postUploadViewModel)
                .tabItem {
                    Image(systemName: "plus.circle")
                }
                .tag(2)
            
            SearchView(viewModel: searchViewModel)
                .onAppear {
                    UITabBar.showTabBar(animated: true)
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(3)
            
            NavigationView {
                ProfileView<ProfileViewModel>()
            }
            .environmentObject(currentUserProfileViewModel)
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
                MainTabView.previousTab = index
            }
        }
        .onAppear {
            MainTabView.tapSelectionChangePublisher
                .sink { index in
                    selection = index
                }.store(in: &subscriptions)
        }
    }
}
