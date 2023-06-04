//
//  SettingsPresenter.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 20.04.2023.
//

import UIKit

final class SettingsPreseneter: SettingsPresenterProtocol {
    
    private weak var view: SettingsViewProtocol?
    private let themeService: ThemeServiceProtocol

    init(view: SettingsViewProtocol?, themeService: ThemeServiceProtocol) {
        self.view = view
        self.themeService = themeService
    }
    
    func viewDidLoad() {
        view?.setupThemeButtonsView(theme: themeService.currentTheme)
    }
    
    func themeDidChange(theme: UIUserInterfaceStyle) {
        themeService.save(theme: theme)
    }
}
