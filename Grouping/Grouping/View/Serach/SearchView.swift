//
//  SearchView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/24.
//

import SwiftUI

struct SearchView: View {
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                searchBar()
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func searchBar() -> some View {
        HStack {
            HStack {
                TextField("search", text: $searchText)
                    .font(.system(size: 24))
                    .padding(.leading, 10)
                
                Button {
                    searchText.removeAll()
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
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
