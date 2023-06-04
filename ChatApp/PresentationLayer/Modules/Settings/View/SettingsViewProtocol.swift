//
//  SettingsViewProtocol.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 20.04.2023.
//

import UIKit

protocol SettingsViewProtocol: AnyObject {
    
    var presenter: SettingsPresenterProtocol? { get set }

    func setupThemeButtonsView(theme: UIUserInterfaceStyle)
}
