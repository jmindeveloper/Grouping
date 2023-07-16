//
//  PhotoLibrary.swift
//  Grouping
//
//  Created by J_Min on 2023/07/15.
//

import UIKit
import Photos
import Combine

typealias FetchAssetResult = (assets: [PHAsset], fetchResult: PHFetchResult<PHAsset>)

final class PhotoLibrary {
    private let phothAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    
    private var assets: FetchAssetResult?
    var collections: [PHAssetCollection] = []
    var currentCollection: PHAssetCollection {
        didSet {
            assets = getAssets(with: currentCollection, isDescendingOrderOfDate: false)
        }
    }
    
    let getAssetsPublisher = CurrentValueSubject<FetchAssetResult?, Never>(nil)
    
    init() {
        self.currentCollection = PHAssetCollection()
        self.collections = getAllAssetCollections()
        collections.forEach {
            print("collectionName --> ", $0.localizedTitle)
        }
        self.currentCollection = collections.filter {
            $0.localizedTitle == "최근 항목"
        }.first ?? PHAssetCollection()
        
        self.assets = getAssets(with: currentCollection, isDescendingOrderOfDate: false)
        
        switch phothAuthorizationStatus {
        case .authorized:
            print("인증됨")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    print("인증됨")
                default:
                    break
                }
            }
        default:
            break
        }
    }
    
    // MARK: - get Collection
    func getAllAssetCollections() -> [PHAssetCollection] {
        var collections = [PHAssetCollection]()
        let smartCollection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
    
        for i in 0..<smartCollection.count {
            let asset = PHAsset.fetchAssets(in: smartCollection[i], options: nil)
            if asset.count != 0 {
                collections.append(smartCollection[i])
            }
        }
        
        // MARK: - UserAlbum
        let userAlbumCollection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        
        for i in 0..<userAlbumCollection.count {
            collections.append(userAlbumCollection[i])
        }
        
        return collections
    }
    
    // MARK: - getAssets
    func getAssets(
        with collection: PHAssetCollection,
        isDescendingOrderOfDate: Bool
    ) -> FetchAssetResult {
        var assets = [PHAsset]()
        
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: isDescendingOrderOfDate)]
        
        let fetchResult = PHAsset.fetchAssets(in: collection, options: fetchOption)
        
        for i in 0..<fetchResult.count {
            assets.append(fetchResult[i])
        }
        
        let result = (assets, fetchResult)
        getAssetsPublisher.send(result)
        
        return result
    }
    
    static func requestImage(with asset: PHAsset?, completion: ((UIImage?) -> Void)? = nil) {
        guard let asset = asset else {
            completion?(nil)
            return
        }
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        option.resizeMode = .none
        option.deliveryMode = .highQualityFormat
        
        let size = CGSize(width: 300, height: 300)
        
        PHCachingImageManager.default().requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFill,
            options: option) { image, info in
                print("image --> ", image)
                completion?(image)
            }
    }
}
