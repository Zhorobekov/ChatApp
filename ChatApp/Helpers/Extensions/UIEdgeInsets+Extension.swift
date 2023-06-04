//
//  UIEdgeInsets+Extension.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 27.02.2023.
//

import UIKit

extension UIEdgeInsets {
    
    init(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        self.init()
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
}
