//
//  UIView+Extension.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 01.03.2023.
//

import UIKit

extension UIView {
    
    enum BorderSide {
        case top
        case bottom
    }

    func setupBorders(sides: [BorderSide], color: UIColor = .separator) {
        if sides.contains(.top) {
            let topBorder = UIView()
            topBorder.backgroundColor = color
            addSubview(topBorder)
            topBorder.anchor(top: topAnchor,
                             leading: leadingAnchor,
                             trailing: trailingAnchor,
                             size: CGSize(width: 0, height: 1))
        }
        
        if sides.contains(.bottom) {
            let bottomBorder = UIView()
            bottomBorder.backgroundColor = color
            addSubview(bottomBorder)
            bottomBorder.anchor(leading: leadingAnchor,
                                bottom: bottomAnchor,
                                trailing: trailingAnchor,
                                size: CGSize(width: 0, height: 1))
        }
    }
}
