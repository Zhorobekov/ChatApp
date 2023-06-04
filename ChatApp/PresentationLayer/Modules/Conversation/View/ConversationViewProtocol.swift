//
//  ConversationViewProtocol.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 19.04.2023.
//

import Foundation

protocol ConversationViewProtocol: AnyObject {
    func setupChannel(name: String, image: String?)
    func setupDataSource()
    func showErrorAlert(message: String)
    func showLoading()
    func hideLoading()
}
