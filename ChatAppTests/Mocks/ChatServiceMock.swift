//
//  ChatServiceMock.swift
//  ChatAppTests
//
//  Created by Эрмек Жоробеков on 09.05.2023.
//

import Combine
@testable import TFSChatTransport
@testable import ChatApp

final class ChatServiceMock: ChatServiceProtocol {

    var invokedCreateChannel = false
    var invokedCreateChannelCount = 0
    var invokedCreateChannelParameters: (name: String, logoUrl: String?)?
    var invokedCreateChannelParametersList = [(name: String, logoUrl: String?)]()
    var stubbedCreateChannelResult: AnyPublisher<Channel, Error>!

    func createChannel(name: String, logoUrl: String?) -> AnyPublisher<Channel, Error> {
        invokedCreateChannel = true
        invokedCreateChannelCount += 1
        invokedCreateChannelParameters = (name, logoUrl)
        invokedCreateChannelParametersList.append((name, logoUrl))
        return stubbedCreateChannelResult
    }

    var invokedLoadChannels = false
    var invokedLoadChannelsCount = 0
    var stubbedLoadChannelsResult: AnyPublisher<[Channel], Error>!

    func loadChannels() -> AnyPublisher<[Channel], Error> {
        invokedLoadChannels = true
        invokedLoadChannelsCount += 1
        return stubbedLoadChannelsResult
    }

    var invokedLoadChannel = false
    var invokedLoadChannelCount = 0
    var invokedLoadChannelParameters: (id: String, Void)?
    var invokedLoadChannelParametersList = [(id: String, Void)]()
    var stubbedLoadChannelResult: AnyPublisher<Channel, Error>!

    func loadChannel(id: String) -> AnyPublisher<Channel, Error> {
        invokedLoadChannel = true
        invokedLoadChannelCount += 1
        invokedLoadChannelParameters = (id, ())
        invokedLoadChannelParametersList.append((id, ()))
        return stubbedLoadChannelResult
    }

    var invokedDeleteChannel = false
    var invokedDeleteChannelCount = 0
    var invokedDeleteChannelParameters: (id: String, Void)?
    var invokedDeleteChannelParametersList = [(id: String, Void)]()
    var stubbedDeleteChannelResult: AnyPublisher<Void, Error>!

    func deleteChannel(id: String) -> AnyPublisher<Void, Error> {
        invokedDeleteChannel = true
        invokedDeleteChannelCount += 1
        invokedDeleteChannelParameters = (id, ())
        invokedDeleteChannelParametersList.append((id, ()))
        return stubbedDeleteChannelResult
    }

    var invokedLoadMessages = false
    var invokedLoadMessagesCount = 0
    var invokedLoadMessagesParameters: (channelId: String, Void)?
    var invokedLoadMessagesParametersList = [(channelId: String, Void)]()
    var stubbedLoadMessagesResult: AnyPublisher<[Message], Error>!

    func loadMessages(channelId: String) -> AnyPublisher<[Message], Error> {
        invokedLoadMessages = true
        invokedLoadMessagesCount += 1
        invokedLoadMessagesParameters = (channelId, ())
        invokedLoadMessagesParametersList.append((channelId, ()))
        return stubbedLoadMessagesResult
    }

    var invokedSendMessage = false
    var invokedSendMessageCount = 0
    var invokedSendMessageParameters: (text: String, channelId: String, userId: String, userName: String)?
    var invokedSendMessageParametersList = [(text: String, channelId: String, userId: String, userName: String)]()
    var stubbedSendMessageResult: AnyPublisher<Message, Error>!

    func sendMessage(text: String, channelId: String, userId: String, userName: String) -> AnyPublisher<Message, Error> {
        invokedSendMessage = true
        invokedSendMessageCount += 1
        invokedSendMessageParameters = (text, channelId, userId, userName)
        invokedSendMessageParametersList.append((text, channelId, userId, userName))
        return stubbedSendMessageResult
    }
}
