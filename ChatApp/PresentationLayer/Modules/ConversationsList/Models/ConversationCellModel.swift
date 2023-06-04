//
//  ConversationCellModel.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 07.03.2023.
//

import UIKit

struct ConversationCellModel: Hashable {
    let id = UUID()
    let name: String
    let message: String?
    let date: Date?
    let isOnline: Bool
    let hasUnreadMessages: Bool
    let avatarImage: UIImage? 
}
