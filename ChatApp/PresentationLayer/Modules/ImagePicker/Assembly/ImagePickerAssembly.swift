//
//  ImagePickerAssembly.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 28.04.2023.
//

import UIKit

final class ImagePickerAssembly {

    private let serviceAssembly: ServiceAssembly

    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeImagePickerModule(imagePickerDelegate: ImagePickerDelegate?) -> UINavigationController {
        let view = ImagePickerViewController()
        let presenter = ImagePickerPresenter(view: view,
                                             pixabayService: serviceAssembly.pixabayService,
                                             userService: serviceAssembly.userService,
                                             imagePickerDelegate: imagePickerDelegate)
        view.presenter = presenter
        return UINavigationController(rootViewController: view)
    }
}
