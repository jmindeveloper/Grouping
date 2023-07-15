//
//  SelectedImage.swift
//  Grouping
//
//  Created by J_Min on 2023/07/15.
//

import SwiftUI

struct SelectedImage: View {
    @State var imageName: String
    @State var selected: Bool = true
    @State var selectedIndex: Int = 0
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
                    .onTapGesture {
                        selected.toggle()
                    }
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
}

struct SelectedImageView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedImage(imageName: "test_image_1")
            .frame(width: Constant.screenWidth / 3, height: Constant.screenWidth / 3)
//            .clipped()
    }
}
