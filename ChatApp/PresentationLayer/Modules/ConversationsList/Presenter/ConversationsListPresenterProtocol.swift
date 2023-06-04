//
//  ConversationsListPresenterProtocol.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 20.04.2023.
//

import UIKit

protocol ConversationsListPresenterProtocol {
    var currentTheme: UIUserInterfaceStyle { get }
    var channels: [ChannelModel] { get }

    func viewDidLoad()
    func didSelectRowAt(at index: Int)
    func deleteChannel(at index: Int)
    func getChannels()
    func createChannel(name: String?)
}
