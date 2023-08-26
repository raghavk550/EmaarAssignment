//
//  UIViewControllerExtension.swift
//  EmaarTestRaghav
//
//  Created by apple on 26/08/23.
//

import UIKit

extension UIViewController {
    
    // MARK: - Remove text from back button
    
    open override func awakeAfter(using coder: NSCoder) -> Any? {
        navigationItem.backButtonDisplayMode = .minimal // This will help us to remove text
        return super.awakeAfter(using: coder)
    }
}
