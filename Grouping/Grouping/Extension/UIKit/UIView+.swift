//
//  UIView+.swift
//  Grouping
//
//  Created by J_Min on 2023/07/15.
//

import UIKit

extension UIView {
    func allSubviews() -> [UIView] {
        var allSubviews = subviews
        for subview in subviews {
            allSubviews.append(contentsOf: subview.allSubviews())
        }
        return allSubviews
    }
}
