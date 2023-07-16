//
//  HiddenTabBar.swift
//  Grouping
//
//  Created by J_Min on 2023/07/15.
//

import SwiftUI

struct HiddenTabBar: ViewModifier {
    var animated = true
    
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            UITabBar.hideTabBar(animated: animated)
        }
    }
}
