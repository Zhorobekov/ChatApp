//
//  ProfilePresenterOutput.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 28.04.2023.
//

import Foundation
import UIKit

protocol ProfileRouterProtocol: AnyObject {
    func openImagePicker(imagePickerDelegate: ImagePickerDelegate?)
    func openEditModule(newImageData: Data?, transitionDelegate: UIViewControllerTransitioningDelegate)
}
