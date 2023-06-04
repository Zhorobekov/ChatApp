//
//  ConversationsListPresenterOutput.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 20.04.2023.
//

import Foundation

protocol ConversationsListPresenterOutput: AnyObject {
    func moduleWantsToOpenConversation(with channel: ChannelModel)
}
