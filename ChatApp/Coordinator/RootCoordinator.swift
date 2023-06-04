//
//  RootCoordinator.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 20.04.2023.
//

import UIKit

final class RootCoordinator {

    private weak var window: UIWindow?
    private let tabBarController = UITabBarController()
    
    private let conversationsListAssembly: ConversationsListAssembly
    private let settingsAssembly: SettingsAssembly
    private let conversationAssembly: ConversationAssembly
    private let profileAssembly: ProfileAssembly

    init(conversationsListAssembly: ConversationsListAssembly,
         settingsAssembly: SettingsAssembly,
         conversationAssembly: ConversationAssembly,
         profileAssembly: ProfileAssembly) {
        self.conversationsListAssembly = conversationsListAssembly
        self.settingsAssembly = settingsAssembly
        self.conversationAssembly = conversationAssembly
        self.profileAssembly = profileAssembly
    }

    func start(in window: UIWindow) {
        
        let conversationsListView = conversationsListAssembly.makeConversationsListModule(output: self)
        let settingsView = settingsAssembly.makeSettingsModule()
        let profileView = profileAssembly.makeProfileModule()
        
        tabBarController.tabBar.backgroundColor = .systemGray6
        tabBarController.tabBar.setupBorders(sides: [.top], color: .systemGray5)
        tabBarController.viewControllers = [conversationsListView,
                                            settingsView,
                                            profileView]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func openConversation(channel: ChannelModel) {
        let view = conversationAssembly.makeConversationModule(channel: channel)
        guard let navigationController = tabBarController.selectedViewController as? UINavigationController else { return }
        navigationController.pushViewController(view, animated: true)
    }
}

extension RootCoordinator: ConversationsListPresenterOutput {
    func moduleWantsToOpenConversation(with channel: ChannelModel) {
        openConversation(channel: channel)
    }
}
