//
//  SearchView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/24.
//

import SwiftUI

struct SearchView<VM>: View where VM: SearchViewModelInterface {
    @ObservedObject var viewModel: VM
    
    var body: some View {
        NavigationView {
            VStack {
                searchBar()
                if !viewModel.searchText.isEmpty {
                    Divider()
                    NavigationLink {
                        SearchResultView()
                    } label: {
                        searchCollectionCategory(category: "Tag로 검색하기")
                    }
                    Divider()
                    NavigationLink {
                        SearchResultView()
                    } label: {
                        searchCollectionCategory(category: "그룹에서 검색하기")
                    }
                    Divider()
                    NavigationLink {
                        SearchResultView()
                    } label: {
                        searchCollectionCategory(category: "유저 검색하기")
                    }
                    
                    Divider()
                }
                Spacer()
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    private func searchBar() -> some View {
        HStack {
            HStack {
                TextField("search", text: $viewModel.searchText)
                    .font(.system(size: 24))
                    .padding(.leading, 10)
                
                Button {
                    viewModel.searchText.removeAll()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.init(uiColor: .systemGray3))
                }
                .padding(.trailing, 10)
            }
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.primary, lineWidth: 0.5)
            )
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    private func searchCollectionCategory(category: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(category)
                    .font(.system(size: 24, weight: .semibold))
                Text(viewModel.searchText)
            }
            .padding(.leading, 16)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .padding(.trailing, 16)
        }
        .contentShape(Rectangle())
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: SearchViewModel())
    }
}
