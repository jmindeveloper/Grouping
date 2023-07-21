//
//  LocalAlbumGridView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/20.
//

import SwiftUI

struct LocalAlbumGridView<VM>: View where VM: LocalAlbumInterface {
    private var columns = Array(
        repeating: GridItem(
            .flexible(),
            spacing: 0
        ),
        count: 3
    )
    
    @ObservedObject var viewModel: VM
    
    init(viewModel: VM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 2, pinnedViews: .sectionFooters) {
                ForEach(viewModel.assets) { asset in
                    SelectedImage(asset: asset)
                        .select(index: viewModel.getSelectImageNumbers(asset: asset))
                        .frame(width: (Constant.screenWidth - 4) / 3, height: (Constant.screenWidth - 4) / 3)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.tapAction(asset)
                        }
                }
            }
        }
    }
}

struct LocalAlbumGridView_Previews: PreviewProvider {
    static var previews: some View {
        LocalAlbumGridView(viewModel: LocalAlbumGridDefaultViewModel())
    }
}
