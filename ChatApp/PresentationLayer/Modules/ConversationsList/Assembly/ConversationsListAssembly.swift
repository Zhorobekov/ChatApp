//
//  ConversationsListAssembly.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 20.04.2023.
//

import UIKit

final class ConversationsListAssembly {
    
    private let serviceAssembly: ServiceAssembly
    
    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeConversationsListModule(output: ConversationsListPresenterOutput?) -> UINavigationController {
        let view = ConversationsListViewController()
        let fileManager = ChatFileManager()
        let fileService = FileService(fileManager: fileManager)
        let dataService = DataService(coreDataService: CoreDataService(), logger: CoreDataLoggerImpl())
        let presenter = ConversationsListPresenter(view: view,
                                                   fileManager: fileService,
                                                   networkService: serviceAssembly.networkService,
                                                   dataService: dataService,
                                                   themeService: serviceAssembly.themeService,
                                                   userService: serviceAssembly.userService,
                                                   output: output)
        view.presenter = presenter
        view.tabBarItem.image = Constants.Main.tabBarIcon
        view.title = Constants.Main.navigationTitle
        
        let navigationController = UINavigationController(rootViewController: view)
        return navigationController
    }

}
