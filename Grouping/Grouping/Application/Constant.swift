//
//  Constant.swift
//  Grouping
//
//  Created by J_Min on 2023/07/09.
//

import UIKit

struct Constant {
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    static var rootVC: UIViewController? {
        UIApplication.shared.windows.first?.rootViewController
    }
}
