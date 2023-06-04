//
//  ProfileCoordinator.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 03.05.2023.
//

import UIKit

final class ProfileRouter: ProfileRouterProtocol {
    
    private weak var rootView: UIViewController?

    private let imagePickerAssembly: ImagePickerAssembly
    private let editProfileAssembly: EditProfileAssembly
    
    init(rootView: UIViewController?,
         imagePickerAssembly: ImagePickerAssembly,
         editProfileAssembly: EditProfileAssembly) {
        self.rootView = rootView
        self.imagePickerAssembly = imagePickerAssembly
        self.editProfileAssembly = editProfileAssembly
    }

    func openImagePicker(imagePickerDelegate: ImagePickerDelegate?) {
        let view = imagePickerAssembly.makeImagePickerModule(imagePickerDelegate: imagePickerDelegate)
        rootView?.present(view, animated: true)
    }
    
    func openEditModule(newImageData: Data?, transitionDelegate: UIViewControllerTransitioningDelegate) {
        let view = editProfileAssembly.makeEditProfileModule(newImageData: newImageData)
        view.modalPresentationStyle = .overCurrentContext
        view.transitioningDelegate = transitionDelegate
        rootView?.present(view, animated: true)
    }
}
