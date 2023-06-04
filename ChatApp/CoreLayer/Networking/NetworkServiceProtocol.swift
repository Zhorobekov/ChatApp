//
//  NetworkServiceProtocol.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 19.04.2023.
//

import Combine
import TFSChatTransport

protocol NetworkServiceProtocol {
    func getChannels() -> AnyPublisher<[Channel], Error>
    func getMessages(channelId: String) -> AnyPublisher<[Message], Error>
    func createChannel(name: String) -> AnyPublisher<Channel, Error>
    func createMessage(text: String, channelId: String, userId: String, userName: String) -> AnyPublisher<Message, Error>
    func deleteChannel(with id: String) -> AnyPublisher<Void, Error>
    func handleEvents() -> AnyPublisher<ChatEvent, Error>
}
