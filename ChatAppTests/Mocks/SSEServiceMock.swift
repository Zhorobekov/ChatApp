//
//  SSEServiceMock.swift
//  ChatAppTests
//
//  Created by Эрмек Жоробеков on 11.05.2023.
//

import Combine
@testable import ChatApp
@testable import TFSChatTransport

final class SSEServiceMock: SSEServiceProtocol {

    var invokedSubscribeOnEvents = false
    var invokedSubscribeOnEventsCount = 0
    var stubbedSubscribeOnEventsResult: AnyPublisher<ChatEvent, Error>!

    func subscribeOnEvents() -> AnyPublisher<ChatEvent, Error> {
        invokedSubscribeOnEvents = true
        invokedSubscribeOnEventsCount += 1
        return stubbedSubscribeOnEventsResult
    }
}
