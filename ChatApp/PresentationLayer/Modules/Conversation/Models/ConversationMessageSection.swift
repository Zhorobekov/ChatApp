//
//  ConversationMessageSection.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 10.03.2023.
//

import Foundation

struct ConversationMessageSection: Hashable {
    var id: String {
        title + (messages.first?.id ?? " ")
    }
    let title: String
    var messages: [ConversationMessageCellModel]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }

    static func == (lhs: ConversationMessageSection, rhs: ConversationMessageSection) -> Bool {
        lhs.title == rhs.title && lhs.messages.count == rhs.messages.count
    }
}
