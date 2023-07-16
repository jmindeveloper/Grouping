//
//  SelectedImage.swift
//  Grouping
//
//  Created by J_Min on 2023/07/15.
//

import SwiftUI
import Photos

struct SelectedImage: View {
    private var imageName: String
    private var selected: Bool = false
    private var selectedIndex: Int = 0
    private var asset: PHAsset? = nil
    @State private var image: UIImage? = nil
    @State private var isDisAppear: Bool = false
    
    init(imageName: String) {
        self.init(imageName: imageName, selected: false, selectedIndex: -1)
    }
    
    init(asset: PHAsset) {
        self.init(imageName: "", selected: false, selectedIndex: -1, asset: asset)
    }
    
    private init(imageName: String, selected: Bool, selectedIndex: Int, asset: PHAsset? = nil) {
        self.imageName = imageName
        self.selected = selected
        self.selectedIndex = selectedIndex
        self.asset = asset
    }
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()
                } else {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()
                }
            }
            .background(Color.gray)
            .onAppear {
                isDisAppear = false
                PhotoLibrary.requestImage(with: asset) { image in
                    if !isDisAppear {
                        self.image = image
                    } else {
                        self.image = nil
                    }
                }
            }
            .onDisappear {
                image = nil
                isDisAppear = true
            }
            
            if selected {
                Rectangle()
                    .fill(.white)
                    .opacity(0.2)
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer()
                        
                        Text("\(selectedIndex)")
                            .foregroundColor(.white)
                            .font(.system(size: 14 ,weight: .semibold))
                            .background(
                                Circle().fill(.blue)
                                    .frame(width: 25, height: 25)
                            )
                    }
                    .padding(.trailing, 15)
                    
                    Spacer()
                }
                .padding(.top, 10)
            }
        }
    }
    
    func select(index: Int?) -> SelectedImage {
        SelectedImage(
            imageName: imageName,
            selected: index == nil ? false : true,
            selectedIndex: index ?? -1,
            asset: asset
        )
    }
}

struct SelectedImageView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedImage(imageName: "test_image_1")
            .frame(width: Constant.screenWidth / 3, height: Constant.screenWidth / 3)
//            .clipped()
    }
}
