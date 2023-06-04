//
//  EditProfileAssembly.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 04.05.2023.
//

import UIKit

final class EditProfileAssembly {
    
    private let serviceAssembly: ServiceAssembly
    private let imagePickerAssembly: ImagePickerAssembly
    
    init(serviceAssembly: ServiceAssembly,
         imagePickerAssembly: ImagePickerAssembly) {
        self.serviceAssembly = serviceAssembly
        self.imagePickerAssembly = imagePickerAssembly
    }
    
    func makeEditProfileModule(newImageData: Data?) -> UIViewController {
        let view = EditProfileViewController()
        let fileManager = ChatFileManager()
        let fileService = FileService(fileManager: fileManager)
        let router = EditProfileRouter(rootView: view, imagePickerAssembly: imagePickerAssembly)
        let presenter = EditProfilePresenter(view: view,
                                             router: router, fileService: fileService,
                                             userService: serviceAssembly.userService,
                                             newImageData: newImageData)
        view.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: view)
    
        return navigationController
    }
}
