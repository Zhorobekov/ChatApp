//
//  EditProfileViewProtocol.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 03.05.2023.
//

import Foundation

protocol EditProfileViewProtocol: AnyObject {
    var presenter: EditProfilePresenterProtocol? { get set }
    
    func setNewAvatarImage(data: Data?)
    func showLoading()
    func hideLoading()
    func showAlert(isSaved: Bool, message: String)
    func finishEditing()
}
