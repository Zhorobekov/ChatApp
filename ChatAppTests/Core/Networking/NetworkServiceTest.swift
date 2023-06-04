//  NetworkServiceTest.swift
//  ChatAppTests
//
//  Created by Эрмек Жоробеков on 09.05.2023.
//

import XCTest
import Combine
@testable import TFSChatTransport
@testable import ChatApp

final class NetworkServiceTest: XCTestCase {
    
    var chatService: ChatServiceMock!
    var sseService: SSEServiceMock!
    var networkService: NetworkServiceProtocol!
    var chatRequest: Cancellable!
    
    override func setUp() {
        chatService = ChatServiceMock()
        sseService = SSEServiceMock()
        networkService = NetworkService(chatService: chatService, sseService: sseService)
    }
    
    override func tearDown() {
        chatService = nil
        networkService = nil
        chatRequest = nil
    }
    
    func testLoadChannels() {
        // Arrange
        let expected = [Channel(id: "id",
                                name: "newChannel",
                                logoURL: nil,
                                lastMessage: nil,
                                lastActivity: nil)]
        let strub = Result<[Channel], Error>.Publisher(expected).eraseToAnyPublisher()
        chatService.stubbedLoadChannelsResult = strub
        
        // Act
        waitForCompletion(expectationDescription: "Get channels", publisher: networkService.getChannels()) { channels in
            // Assert
            XCTAssertTrue(self.chatService.invokedLoadChannels)
            XCTAssertEqual(self.chatService.invokedLoadChannelsCount, 1)
            
            XCTAssertFalse(channels.isEmpty)
        }
    }
    
    func testGetMessages() {
        // Arrange
        let channelId = "123"
        let expected = [Message(id: "01",
                                text: "Hello",
                                userID: "user",
                                userName: "newUser",
                                date: Date())]
        let stub = Just(expected)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        chatService.stubbedLoadMessagesResult = stub
        
        // Act
        waitForCompletion(expectationDescription: "Get messages", publisher: networkService.getMessages(channelId: channelId)) { messages in
            // Assert
            XCTAssertEqual(self.chatService.invokedLoadMessagesCount, 1)
            XCTAssertEqual(self.chatService.invokedLoadMessagesParameters?.0, channelId)
            XCTAssertTrue(self.chatService.invokedLoadMessages)
            XCTAssertFalse(messages.isEmpty)
        }
    }
    
    func testCreateChannel() {
        let expected = Channel(id: "123",
                                name: "channelName",
                                logoURL: nil,
                                lastMessage: nil,
                                lastActivity: nil)
        let stub = Result<Channel, Error>.Publisher(expected).eraseToAnyPublisher()
        chatService.stubbedCreateChannelResult = stub
        
        waitForCompletion(expectationDescription: "Crete Channel", publisher: networkService.createChannel(name: expected.name)) { channel in
            XCTAssertTrue(self.chatService.invokedCreateChannel)
            XCTAssertEqual(self.chatService.invokedCreateChannelCount, 1)
            XCTAssertEqual(self.chatService.invokedCreateChannelParameters?.0, expected.name)
            XCTAssertEqual(channel.name, expected.name)
        }
    }
    
    func testCreateMessage() {
        let channelId = "channelId"
        let expected = Message(id: "id", text: "text", userID: "userId", userName: "userName", date: Date())
        let stub = Result<Message,Error>.Publisher(expected).eraseToAnyPublisher()
        chatService.stubbedSendMessageResult = stub
        
        waitForCompletion(expectationDescription: "Create Message",
                          publisher: networkService.createMessage(text: expected.text,
                                                                  channelId: channelId,
                                                                  userId: expected.userID,
                                                                  userName: expected.userName)) { message in
            XCTAssertTrue(self.chatService.invokedSendMessage)
            XCTAssertEqual(self.chatService.invokedSendMessageCount, 1)
            XCTAssertEqual(self.chatService.invokedSendMessageParameters?.channelId, channelId)
            XCTAssertEqual(self.chatService.invokedSendMessageParameters?.userName, expected.userName)
            XCTAssertEqual(self.chatService.invokedSendMessageParameters?.userId, expected.userID)
            XCTAssertEqual(self.chatService.invokedSendMessageParameters?.text, expected.text)
            XCTAssertEqual(message.id, expected.id)
        }
    }
    
    func testDeleteChannel() {
        let expected = "channelId"
        
        let stub = Result<Void,Error>.Publisher(()).eraseToAnyPublisher()
        chatService.stubbedDeleteChannelResult = stub
        
        waitForCompletion(expectationDescription: "Delete Channel", publisher: networkService.deleteChannel(with: expected)) { _ in
            XCTAssertTrue(self.chatService.invokedDeleteChannel)
            XCTAssertEqual(self.chatService.invokedDeleteChannelCount, 1)
            XCTAssertEqual(self.chatService.invokedDeleteChannelParameters?.id, expected)
        }
    }
    
    func testHandleEvents() {
        let expected: ChatEvent = ChatEvent(eventType: .add, resourceID: "123")
        
        let stub = Result<ChatEvent,Error>.Publisher(expected).eraseToAnyPublisher()
        sseService.stubbedSubscribeOnEventsResult = stub
        
        waitForCompletion(expectationDescription: "handle events", publisher: networkService.handleEvents()) { event in
            XCTAssertTrue(self.sseService.invokedSubscribeOnEvents)
            XCTAssertEqual(self.sseService.invokedSubscribeOnEventsCount, 1)
            XCTAssertEqual(expected.eventType, event.eventType)
            XCTAssertEqual(expected.resourceID, event.resourceID)
        }
    }
}

private extension NetworkServiceTest {
    func waitForCompletion<T>(expectationDescription: String,publisher: AnyPublisher<T, Error>, completion: @escaping(T) -> Void) {
        let expectation = XCTestExpectation(description: expectationDescription)
        chatRequest = publisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
            }, receiveValue: { value in
                completion(value)
            })
        let result = XCTWaiter.wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(result, .completed)
    }
}

