//
//  ConversationAssembly.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 20.04.2023.
//

import UIKit

final class ConversationAssembly {
    
    private let serviceAssembly: ServiceAssembly
    
    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeConversationModule(channel: ChannelModel) -> UIViewController {
        let view = ConversationViewController()
        let dataService = DataService(coreDataService: CoreDataService(), logger: CoreDataLoggerImpl())
        let presenter = ConversationsPresenter(view: view,
                                               networkService: serviceAssembly.networkService,
                                               dataService: dataService,
                                               userService: serviceAssembly.userService,
                                               channel: channel)
        view.presenter = presenter
        view.hidesBottomBarWhenPushed = true
        return view
    }
}
