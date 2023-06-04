//
//  ConversationsPresenterProtocol.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 20.04.2023.
//

import Foundation

protocol ConversationsPresenterProtocol {
    var sections: [ConversationMessageSection] { get }

    func viewDidDissapear()
    func viewDidLoad()
    func sendMessage(text: String) throws
    func getTitleFor(section: Int) -> String
}
