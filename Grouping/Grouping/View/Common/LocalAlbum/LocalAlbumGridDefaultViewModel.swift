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
    var tapAction: ((_ asset: PHAsset) -> Void) { get }
    var collections: [PHAssetCollection] { get }
    var currentCollectionTitle: String { get }
    var multiSelect: Bool { get set }
    
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
    
    var multiSelect: Bool = true
    
    private var lastNumber: Int = 0
    var tapAction: ((PHAsset) -> Void) {
        get {
            if multiSelect {
                return select(asset:)
            } else {
                return selectJustOne(asset:)
            }
        }
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
    
    private func selectJustOne(asset: PHAsset) {
        if selectedImageIndexes.isEmpty {
            selectedImageIndexes.append((assets.firstIndex(of: asset) ?? -1, -1, asset))
        } else {
            if selectedImageIndexes[0].asset === asset {
                selectedImageIndexes.removeAll()
            } else {
                selectedImageIndexes.removeAll()
                selectedImageIndexes.append((assets.firstIndex(of: asset) ?? -1, -1, asset))
            }
        }
    }
    
    private func select(asset: PHAsset) {
        let index = selectedImageIndexes.firstIndex {
            $0.asset == asset
        }
        
        if let index = index {
            // TODO: - 제거
            deSelect(selectedImageIndex: index)
        } else {
            // TODO: - 추가
            let index = assets.firstIndex(of: asset) ?? -1
            selectedImageIndexes.append((index, lastNumber + 1, assets[index]))
            lastNumber += 1
        }
    }
    
    private func deSelect(selectedImageIndex: Int) {
        let range: ClosedRange<Int> = selectedImageIndex...selectedImageIndexes.count - 1
        let numberChangeImages = selectedImageIndexes[range]
            .map {
                var v = $0
                v.number -= 1
                return v
            }
        
        selectedImageIndexes.replaceSubrange(range, with: numberChangeImages)
        selectedImageIndexes.remove(at: selectedImageIndex)
        lastNumber -= 1
    }
}
