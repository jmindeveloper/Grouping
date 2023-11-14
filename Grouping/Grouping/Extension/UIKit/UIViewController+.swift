//
//  UIViewController+.swift
//  Grouping
//
//  Created by J_Min on 11/15/23.
//

import UIKit

extension UIViewController {
    func dismissToRoot(animate: Bool, completion: (() -> Void)? = nil) {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController?.dismiss(animated: animate, completion: completion)
        }
    }
}
