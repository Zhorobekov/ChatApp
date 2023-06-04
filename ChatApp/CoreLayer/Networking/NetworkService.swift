//
//  NetworkService.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 04.04.2023.
//

import TFSChatTransport
import Combine

final class NetworkService {
    private let chatService: ChatServiceProtocol
    private let queue = DispatchQueue.global(qos: .userInteractive)
    private var channelsRequests: Set<AnyCancellable> = []
    private let sseService: SSEServiceProtocol

    init(chatService: ChatServiceProtocol, sseService: SSEServiceProtocol) {
        self.chatService = chatService
        self.sseService = sseService
    }
    
    deinit {
        channelsRequests = []
    }

    private func performRequest<T>(publisher: AnyPublisher<T, Error>) -> AnyPublisher<T, Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            self.queue.async {
                publisher
                    .sink { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            promise(.failure(error))
                        }
                    } receiveValue: { value in
                        promise(.success(value))
                    }
                    .store(in: &self.channelsRequests)
            }
        }
        .eraseToAnyPublisher()
    }
}

extension NetworkService: NetworkServiceProtocol {

    func getChannels() -> AnyPublisher<[Channel], Error> {
        performRequest(publisher: chatService.loadChannels())
    }
    
    func getMessages(channelId: String) -> AnyPublisher<[Message], Error> {
        performRequest(publisher: chatService.loadMessages(channelId: channelId))
    }
    
    func createChannel(name: String) -> AnyPublisher<Channel, Error> {
        performRequest(publisher: chatService.createChannel(name: name, logoUrl: nil))
    }
    
    func createMessage(text: String, channelId: String, userId: String, userName: String) -> AnyPublisher<Message, Error> {
        performRequest(publisher: chatService.sendMessage(text: text, channelId: channelId, userId: userId, userName: userName))
    }
    
    func deleteChannel(with id: String) -> AnyPublisher<Void, Error> {
        performRequest(publisher: chatService.deleteChannel(id: id))
    }
    
    func handleEvents() -> AnyPublisher<ChatEvent, Error> {
        sseService.subscribeOnEvents()
    }
}
