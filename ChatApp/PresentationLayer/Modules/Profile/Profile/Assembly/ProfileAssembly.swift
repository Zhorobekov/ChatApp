//
//  ProfileAssembly.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 20.04.2023.
//

import UIKit

final class ProfileAssembly {
    
    private let serviceAssembly: ServiceAssembly
    private let imagePickerAssembly: ImagePickerAssembly
    
    init(serviceAssembly: ServiceAssembly,
         imagePickerAssembly: ImagePickerAssembly) {
        self.serviceAssembly = serviceAssembly
        self.imagePickerAssembly = imagePickerAssembly
    }
    
    func makeProfileModule() -> UINavigationController {
        let view = ProfileViewController()
        let editProfileAssembly = EditProfileAssembly(serviceAssembly: serviceAssembly, imagePickerAssembly: imagePickerAssembly)
        let router = ProfileRouter(rootView: view, imagePickerAssembly: imagePickerAssembly, editProfileAssembly: editProfileAssembly)
        let presenter = ProfilePresenter(view: view, router: router, userService: serviceAssembly.userService)
        
        view.presenter = presenter
        view.tabBarItem.title = Constants.Profile.title
        view.tabBarItem.image = Constants.Profile.tabBarIcon
        
        let navigationController = UINavigationController(rootViewController: view)
    
        return navigationController
    }
}
