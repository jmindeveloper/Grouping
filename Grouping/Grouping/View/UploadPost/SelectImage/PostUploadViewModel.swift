//
//  PostUploadViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/15.
//

import Foundation
import Combine
import Photos

extension PHAsset: Identifiable { }

protocol PostUploadViewModelInterface: ObservableObject {
    var assets: [PHAsset] { get set }
    var selectedImageIndexes: [(index: Int, number: Int, asset: PHAsset)] { get set }
    var collections: [PHAssetCollection] { get }
    var currentCollectionTitle: String { get }
    var tags: [String] { get set }
    var contentText: String { get set }
    var selectedGroupId: String? { get set }
    
    func select(index: Int)
    func select(asset: PHAsset)
    func getSelectImageNumbers(index: Int) -> Int?
    func getSelectImageNumbers(asset: PHAsset) -> Int?
    func selectCollection(_ index: Int)
    func appendTag(_ tag: String)
    func removeTag(_ tag: String)
    func upload()
}

final class PostUploadViewModel: PostUploadViewModelInterface {
    private let library = PhotoLibrary()
    private let postManager: PostManagementManagerInterface = PostManagementManager()
    
    @Published var tags: [String] = []
    @Published var contentText: String = ""
    @Published var selectedGroupId: String? = nil
    @Published var assets: [PHAsset] = []
    @Published var selectedImageIndexes: [(index: Int, number: Int, asset: PHAsset)] = [] {
        didSet {
            if selectedImageIndexes.count > 5 {
                selectedImageIndexes.removeLast()
                lastNumber -= 1
            }
        }
    }
    
    var collections: [PHAssetCollection] {
        library.collections
    }
    
    var currentCollectionTitle: String {
        library.currentCollection.localizedTitle ?? ""
    }
    
    private var lastNumber: Int = 0
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        binding()
    }
    
    deinit {
        print("SelectImageViewModel", #function)
    }
    
    private func binding() {
        library.getAssetsPublisher
            .sink { [weak self] result in
                self?.assets = result?.assets ?? []
                self?.objectWillChange.send()
            }.store(in: &subscriptions)
    }
    
    func select(index: Int) {
        let isContains = selectedImageIndexes.contains {
            $0.index == index
        }
        if isContains {
            // TODO: - 제거
            deSelect(assetIndex: index)
        } else {
            // TODO: - 추가
            selectedImageIndexes.append((index, lastNumber + 1, assets[index]))
            lastNumber += 1
        }
    }
    
    func select(asset: PHAsset) {
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
    
    private func deSelect(assetIndex: Int) {
        let arrayIndex = selectedImageIndexes.firstIndex {
            $0.index == assetIndex
        }
        guard let arrayIndex = arrayIndex else {
            return
        }
        
        let range: ClosedRange<Int> = arrayIndex...selectedImageIndexes.count - 1
        let numberChangeImages = selectedImageIndexes[range]
            .map {
                var v = $0
                v.number -= 1
                return v
            }
        
        selectedImageIndexes.replaceSubrange(range, with: numberChangeImages)
        selectedImageIndexes.removeAll {
            $0.index == assetIndex
        }
        lastNumber -= 1
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
    
    func getSelectImageNumbers(index: Int) -> Int? {
        let index = selectedImageIndexes.firstIndex {
            index == $0.index
        }
        
        if index == nil {
            return nil
        } else {
            return selectedImageIndexes[index!].number
        }
    }
    
    func selectCollection(_ index: Int) {
        assets.removeAll()
        resetSelectedAsset()
        library.currentCollection = collections[index]
    }
    
    private func resetSelectedAsset() {
        selectedImageIndexes.removeAll()
        lastNumber = 0
    }
    
    func appendTag(_ tag: String) {
        if !tags.contains(tag) {
            tags.append(tag)
        }
    }
    
    func removeTag(_ tag: String) {
        if let index = tags.firstIndex(of: tag) {
            tags.remove(at: index)
        }
    }
    
    func upload() {
        let selectAssets = selectedImageIndexes.map { $0.asset }
        
        library.getImageDate(with: selectAssets, quality: 0.3) { [weak self] data in
            guard let self = self else {
                return
            }
            self.postManager.upload(
                images: data,
                content: self.contentText,
                location: nil,
                tags: tags) { post in
                    
                }
        }
    }
}
