//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 19.02.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator: RootCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupLogger()
        ApplicationLogger.instance?.printApplicationState(toState: .foregroundInactive, method: #function)
        setupRoot()

        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        ApplicationLogger.instance?.printApplicationState(toState: .foregroundActive, method: #function)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        ApplicationLogger.instance?.printApplicationState(toState: .background, method: #function)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        ApplicationLogger.instance?.printApplicationState(toState: .foregroundInactive, method: #function)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        ApplicationLogger.instance?.printApplicationState(toState: .foregroundInactive, method: #function)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        ApplicationLogger.instance?.printApplicationState(toState: .unattached, method: #function)
    }

    private func setupRoot() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let serviceAssembly = ServiceAssembly()
        window.overrideUserInterfaceStyle = serviceAssembly.themeService.currentTheme
       
        let imagePickerAssembly = ImagePickerAssembly(serviceAssembly: serviceAssembly)
        let profileAssembly = ProfileAssembly(serviceAssembly: serviceAssembly,
                                              imagePickerAssembly: imagePickerAssembly)
        
        coordinator = RootCoordinator(conversationsListAssembly: ConversationsListAssembly(serviceAssembly: serviceAssembly),
                                      settingsAssembly: SettingsAssembly(serviceAssembly: serviceAssembly),
                                      conversationAssembly: ConversationAssembly(serviceAssembly: serviceAssembly),
                                      profileAssembly: profileAssembly)
        coordinator?.start(in: window)
    }
    
    private func setupLogger() {
        #if DEBUG
        ApplicationLogger.instance = ApplicationLoggerImpl()
        #endif
    }
}
