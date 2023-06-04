//
//  ServiceAssembly.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 19.04.2023.
//

import Foundation
import TFSChatTransport

final class ServiceAssembly {
    
    lazy var themeService: ThemeServiceProtocol = {
        ThemeService()
    }()
    
    lazy var networkService: NetworkServiceProtocol = {
        let chatServicesHost = getString(for: "servicesHost")
        let chatServicesPort = Int(getString(for: "servicesPort")) ?? 0
        let chatService = ChatService(host: chatServicesHost, port: chatServicesPort)
        let sseService = SSEService(host: chatServicesHost, port: chatServicesPort)
        return NetworkService(chatService: chatService, sseService: sseService)
    }()
    
    lazy var userService: UserServiceProtocol = {
        UserService()
    }()
    
    let pixabayService: PixabayServiceProtocol = PixabayService()
    
    private func getString(for key: String) -> String {
        Bundle.main.object(forInfoDictionaryKey: key) as? String ?? ""
    }
}
