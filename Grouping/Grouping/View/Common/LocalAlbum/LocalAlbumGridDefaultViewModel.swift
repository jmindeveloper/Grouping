//
//  LocalAlbumGridDefaultViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/21.
//

import Foundation
import Photos
import Combine

protocol LocalAlbumInterface: ObservableObject {
    var assets: [PHAsset] { get set }
    var tapAction: ((_ asset: PHAsset) -> Void) { get set }
    var collections: [PHAssetCollection] { get }
    var currentCollectionTitle: String { get }
    
    func getSelectImageNumbers(asset: PHAsset) -> Int?
}

class LocalAlbumGridDefaultViewModel: LocalAlbumInterface {
    /// photoLibrary
    let library = PhotoLibrary()
    /// collection들
    var collections: [PHAssetCollection] {
        library.collections
    }
    /// 현재 collection의 타이틀
    var currentCollectionTitle: String {
        library.currentCollection.localizedTitle ?? ""
    }
    /// 현재 collection의 asset
    @Published var assets: [PHAsset] = []
    /// 선택한 이미지
    /// asset의 몇번째 이미지인지, 몇번째로 선택한건지, asset
    @Published var selectedImageIndexes: [(index: Int, number: Int, asset: PHAsset)] = []
    var tapAction: ((PHAsset) -> Void) {
        get {
            { _ in }
        }
        set { }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        binding()
    }
    
    private func binding() {
        library.getAssetsPublisher
            .sink { [weak self] result in
                self?.assets = result?.assets ?? []
                self?.objectWillChange.send()
            }.store(in: &subscriptions)
    }
    
    /// 선택된 이미지중 몇번째 index인지
    /// 선택된 이미지에 없으면 return nil
    func getSelectImageNumbers(asset: PHAsset) -> Int? {
        let index = selectedImageIndexes.firstIndex {
            asset == $0.asset
        }
        
        if index == nil {
            return nil
        } else {
            return selectedImageIndexes[index!].number
        }
    }
}
