//
//  UIColor+Extension.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 13.03.2023.
//

import UIKit

extension UIColor {
    
    static func color(light: UIColor, dark: UIColor) -> UIColor {
        .init { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }

    static var containerGray: UIColor {
        UIColor.color(light: UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1),
                      dark: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))
    }
    
    static var labelGray: UIColor {
        UIColor.color(light: UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 0.6),
                      dark: UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 0.6))
    }
    
    static var labelGrayInvert: UIColor {
        UIColor.color(light: UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 0.6),
                      dark: UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1))
    }
    
    static var navigationColor: UIColor {
        UIColor.color(light: UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8),
                      dark: UIColor(red: 0, green: 0, blue: 0, alpha: 0.5))
    }
}
