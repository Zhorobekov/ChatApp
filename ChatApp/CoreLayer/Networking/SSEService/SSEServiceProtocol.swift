//
//  SSEServiceProtocol.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 11.05.2023.
//

import Combine
import TFSChatTransport

protocol SSEServiceProtocol {
    func subscribeOnEvents() -> AnyPublisher<ChatEvent, Error>
}
