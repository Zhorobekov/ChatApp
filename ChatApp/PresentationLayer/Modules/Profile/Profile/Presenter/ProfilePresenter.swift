//
//  ProfilePresenter.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 03.05.2023.
//

import Foundation
import Combine
import UIKit

final class ProfilePresenter: ProfilePresenterProtocol {
    
    private weak var view: ProfileViewProtocol?
    private let userService: UserServiceProtocol
    private let router: ProfileRouterProtocol

    var currentUserSubject: CurrentValueSubject<User?, Never> {
        userService.currentUserSubject
    }
     
    init(view: ProfileViewProtocol?, router: ProfileRouterProtocol, userService: UserServiceProtocol) {
        self.view = view
        self.router = router
        self.userService = userService
    }
    
    func downloadImageTapped() {
        router.openImagePicker(imagePickerDelegate: self)
    }
    
    func editButtonTapped(transitionDelegate: UIViewControllerTransitioningDelegate) {
        router.openEditModule(newImageData: nil, transitionDelegate: transitionDelegate)
    }
    
    func avatarImageDidChange(imageData: Data?, transitionDelegate: UIViewControllerTransitioningDelegate) {
        router.openEditModule(newImageData: imageData, transitionDelegate: transitionDelegate)
    }
}

extension ProfilePresenter: ImagePickerDelegate {
    func localImageDidChange(imageData: Data?) {
        guard let view = view as? UIViewControllerTransitioningDelegate else { return }
        avatarImageDidChange(imageData: imageData, transitionDelegate: view)
    }
}
