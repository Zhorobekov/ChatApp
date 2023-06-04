//
//  ProfilePresenterProtocol.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 04.05.2023.
//

import UIKit
import Combine

protocol ProfilePresenterProtocol {
    var currentUserSubject: CurrentValueSubject<User?, Never> { get }
    
    func downloadImageTapped()
    func editButtonTapped(transitionDelegate: UIViewControllerTransitioningDelegate)
    func avatarImageDidChange(imageData: Data?, transitionDelegate: UIViewControllerTransitioningDelegate)
}
