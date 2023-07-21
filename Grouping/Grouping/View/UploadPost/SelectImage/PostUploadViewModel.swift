//
//  PostUploadViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/15.
//

import Foundation
import Combine
import Photos

protocol PostUploadViewModelInterface: LocalAlbumInterface {
    var selectedImageIndexes: [(index: Int, number: Int, asset: PHAsset)] { get set }
    var tags: [String] { get set }
    var contentText: String { get set }
    var selectedGroup: Group? { get set }
    
    func selectCollection(_ index: Int)
    func appendTag(_ tag: String)
    func removeTag(_ tag: String)
    func upload()
}

final class PostUploadViewModel: LocalAlbumGridDefaultViewModel, PostUploadViewModelInterface {
    private let postManager: PostManagementManagerInterface = PostManagementManager()
    
    @Published var tags: [String] = []
    @Published var contentText: String = ""
    @Published var selectedGroup: Group? = nil
    override var selectedImageIndexes: [(index: Int, number: Int, asset: PHAsset)] {
        didSet {
            if selectedImageIndexes.count > 5 {
                selectedImageIndexes.removeLast()
                lastNumber -= 1
            }
        }
    }
    
    private var lastNumber: Int = 0
    
    private var subscriptions = Set<AnyCancellable>()
    
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
        
        library.getImageData(with: selectAssets, quality: 0.3) { [weak self] data in
            guard let self = self else {
                return
            }
            self.postManager.upload(
                images: data,
                content: self.contentText,
                location: nil,
                tags: tags,
                groupId: self.selectedGroup?.groupId
            ) { post in
                
            }
        }
    }
}
