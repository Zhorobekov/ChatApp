//
//  EditProfilePresenter.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 04.05.2023.
//

import Foundation
import Combine

final class EditProfilePresenter: EditProfilePresenterProtocol {
    
    private weak var view: EditProfileViewProtocol?
    private let router: EditProfileRouterProtocol
    private let fileService: FileServiceProtocol
    private let userService: UserServiceProtocol
    private let newImageData: Data?

    private var initialUser: User?
    private var isSaveTaskCompleted = false
    
    private var saveUserRequest: Cancellable?
    private var saveInitialUserRequest: Cancellable?

    var currentUserSubject: CurrentValueSubject<User?, Never> {
        userService.currentUserSubject
    }

    init(view: EditProfileViewProtocol?,
         router: EditProfileRouterProtocol,
         fileService: FileServiceProtocol,
         userService: UserServiceProtocol,
         newImageData: Data?) {
        self.view = view
        self.router = router
        self.fileService = fileService
        self.userService = userService
        self.newImageData = newImageData
    }
    
    func viewDidDisappear() {
        saveUserRequest = nil
        saveInitialUserRequest = nil
    }
    
    func viewDidLoad() {
        initialUser = userService.currentUserSubject.value
        setNewImageIfNeeded()
    }
    
    func saveUser(name: String?, bio: String?, avatarImageData: Data?) {
        isSaveTaskCompleted = false
        view?.showLoading()
        let user = User(id: currentUserSubject.value?.id ?? UUID().uuidString,
                        name: name,
                        bio: bio,
                        avatarImage: avatarImageData)
        saveUserRequest = fileService.saveUser(user)
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.view?.hideLoading()
            }, receiveValue: { [weak self] isSaved in
                guard let self else { return }
                if isSaved {
                    self.userService.setUserSubject(user: user)
                    self.initialUser = user
                    self.view?.showAlert(isSaved: isSaved, message: "You are breathtaking")
                    self.view?.finishEditing()
                    self.isSaveTaskCompleted = true
                } else {
                    self.view?.showAlert(isSaved: isSaved, message: "Try again")
                }
            })
    }
    
    func cancelButtonTapped(completion: () -> Void) {
        returnInitialUser()
        view?.finishEditing()
        completion()
    }
    
    func downloadImageTapped() {
        router.openImagePicker(delegate: self)
    }
    
    private func returnInitialUser() {
        if let user = initialUser, !isSaveTaskCompleted {
            userService.setUserSubject(user: user)
            saveUserRequest = nil
            saveInitialUserRequest = fileService.saveUser(user)
                .subscribe(on: DispatchQueue.global(qos: .userInteractive))
                .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            view?.hideLoading()
        } else if initialUser == nil, !isSaveTaskCompleted {
            userService.setUserSubject(user: nil)
            view?.hideLoading()
        }
    }
    
    private func setNewImageIfNeeded() {
        guard let newImageData else { return }
        view?.setNewAvatarImage(data: newImageData)
    }
}

extension EditProfilePresenter: ImagePickerDelegate {
    func localImageDidChange(imageData: Data?) {
        view?.setNewAvatarImage(data: imageData)
    }
}
