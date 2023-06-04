//
//  ConversationListViewProtocol.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 21.04.2023.
//

import Foundation

protocol ConversationsListViewProtocol: AnyObject {
    var presenter: ConversationsListPresenterProtocol? { get set }
    func showLoading()
    func hideLoading()
    func showErrorAlert(message: String)
    func reloadData()
    func reload(channel: ChannelModel)
}
