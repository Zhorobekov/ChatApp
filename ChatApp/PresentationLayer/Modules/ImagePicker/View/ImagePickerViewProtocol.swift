//
//  ImagePickerViewProtocol.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 28.04.2023.
//

import Foundation

protocol ImagePickerViewProtocol: AnyObject {
    var presenter: ImagePickerPresenterProtocol? { get set }
    
    func showLoading()
    func hideLoading()
    func showErrorAlert(message: String)
    func reloadData()
}
