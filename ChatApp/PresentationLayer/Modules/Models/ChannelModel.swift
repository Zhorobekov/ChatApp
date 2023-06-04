//
//  ChannelCellViewModel.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 04.04.2023.
//

import Foundation
import TFSChatTransport

struct ChannelModel: Hashable {
    let id: String
    let name: String
    let logoURL: String?
    let lastMessage: String?
    let lastActivity: Date?
    
    init(id: String, name: String, logoURL: String?, lastMessage: String?, lastActivity: Date?) {
        self.id = id
        self.name = name
        self.logoURL = logoURL
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }

    init(channel: Channel) {
        self.id = channel.id
        self.name = channel.name
        self.logoURL = channel.logoURL
        self.lastMessage = channel.lastMessage
        self.lastActivity = channel.lastActivity
    }
}
