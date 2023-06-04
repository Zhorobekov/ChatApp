//
//  ConversationMessageCellModel.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 10.03.2023.
//

import Foundation

enum MessageType {
    case incoming
    case outcoming
}

enum ContentType {
    case text
    case image
}

struct ConversationMessageCellModel: Hashable {
    let id: String
    let userId: String
    let text: String
    let userName: String
    let date: Date
    let messageType: MessageType
    var isFirstMessage = true
    var isLastMessage = true
    var contentType: ContentType {
        text.contains("https") ? .image : .text
    }
    
    init(message: MessageProtocol, currentUserId: String) {
        self.id = message.id
        self.messageType = message.userID == currentUserId ? .outcoming : .incoming
        self.userName = message.userName
        self.userId = message.userID
        self.text = message.text
        self.date = message.date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ConversationMessageCellModel, rhs: ConversationMessageCellModel) -> Bool {
        lhs.id == rhs.id
        && lhs.text == rhs.text
        && lhs.userId == rhs.userId
        && lhs.date == rhs.date
    }
}
