//
//  PhotoLibrary.swift
//  Grouping
//
//  Created by J_Min on 2023/07/15.
//

import Photos

final class PhotoLibrary {
    private let phothAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    
    init() {
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
}
