//
//  Color+.swift
//  Grouping
//
//  Created by J_Min on 2023/07/10.
//

import SwiftUI

extension Color {
    init(uiColor: UIColor) {
        self.init(red: uiColor.rgba.red, green: uiColor.rgba.green, blue: uiColor.rgba.blue, opacity: uiColor.rgba.alpha)
    }
    
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
