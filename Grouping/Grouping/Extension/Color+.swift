//
//  Color+.swift
//  Grouping
//
//  Created by J_Min on 2023/07/10.
//

import SwiftUI

extension Color {
    init(uc: UIColor) {
        self.init(red: uc.rgba.red, green: uc.rgba.green, blue: uc.rgba.blue, opacity: uc.rgba.alpha)
    }
}
