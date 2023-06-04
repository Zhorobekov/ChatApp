//
//  SettingsAssembly.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 20.04.2023.
//

import UIKit

final class SettingsAssembly {
    
    private let serviceAssembly: ServiceAssembly
    
    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeSettingsModule() -> UIViewController {
        let view = SettingsViewController()
        let presenter = SettingsPreseneter(view: view, themeService: serviceAssembly.themeService)
        view.presenter = presenter
        view.tabBarItem.title = Constants.Settings.title
        view.tabBarItem.image = Constants.Settings.tabBarIcon
        return view 
    }
}
