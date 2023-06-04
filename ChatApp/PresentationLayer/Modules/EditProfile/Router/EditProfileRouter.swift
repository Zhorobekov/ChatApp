//
//  EditProfileCoordinator.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 04.05.2023.
//

import UIKit

final class EditProfileRouter: EditProfileRouterProtocol {
    
    private weak var rootView: UIViewController?
    private let imagePickerAssembly: ImagePickerAssembly

    init(rootView: UIViewController?,
         imagePickerAssembly: ImagePickerAssembly) {
        self.rootView = rootView
        self.imagePickerAssembly = imagePickerAssembly
    }
    
    func openImagePicker(delegate: ImagePickerDelegate?) {
        let view = imagePickerAssembly.makeImagePickerModule(imagePickerDelegate: delegate)
        rootView?.present(view, animated: true)
    }
}
