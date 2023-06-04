//
//  ChatServiceProtocol.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 09.05.2023.
//

import Foundation
import Combine
import TFSChatTransport

protocol ChatServiceProtocol {
    func createChannel(name: String, logoUrl: String?) -> AnyPublisher<Channel, Error>
    func loadChannels() -> AnyPublisher<[Channel], Error>
    func loadChannel(id: String) -> AnyPublisher<Channel, Error>
    func deleteChannel(id: String) -> AnyPublisher<Void, Error>
    func loadMessages(channelId: String) -> AnyPublisher<[Message], Error>
    func sendMessage(text: String, channelId: String, userId: String, userName: String) -> AnyPublisher<Message, Error>
}
