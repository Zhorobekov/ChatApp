//
//  EditProfilePresenterProtocol.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 04.05.2023.
//

import Foundation
import Combine

protocol EditProfilePresenterProtocol {
    var currentUserSubject: CurrentValueSubject<User?, Never> { get }

    func saveUser(name: String?, bio: String?, avatarImageData: Data?)
    func downloadImageTapped()
    func viewDidLoad()
    func viewDidDisappear()
    func cancelButtonTapped(completion: () -> Void)
}
