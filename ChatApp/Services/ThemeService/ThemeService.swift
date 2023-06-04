//
//  ThemeManager.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 13.03.2023.
//

import UIKit

protocol ThemeServiceProtocol {
    var currentTheme: UIUserInterfaceStyle { get }
    func save(theme: UIUserInterfaceStyle)
}

final class ThemeService: ThemeServiceProtocol {
    private let userDefaults = UserDefaults.standard
    private let themeKey = "app_theme"

    var currentTheme: UIUserInterfaceStyle {
        guard
            let theme = UIUserInterfaceStyle(rawValue: userDefaults.integer(forKey: themeKey)),
            theme != .unspecified
        else {
            save(theme: .light)
            return UIUserInterfaceStyle.light
        }
        return theme
    }
    
    func save(theme: UIUserInterfaceStyle) {
        userDefaults.set(theme.rawValue, forKey: themeKey)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let currentWindow = appDelegate.window else { return }
        currentWindow.overrideUserInterfaceStyle = theme
    }
}
