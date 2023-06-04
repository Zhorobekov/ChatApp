//
//  ConversationsPresenter.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 08.03.2023.
//

import UIKit
import Combine

enum UserError: Error {
    case noUser
}

final class ConversationsPresenter: ConversationsPresenterProtocol {

    private let networkService: NetworkServiceProtocol
    private let dataService: DataServiceProtocol
    private let userService: UserServiceProtocol
    private let channel: ChannelModel
    private weak var view: ConversationViewProtocol?

    private var messagesRequest: Cancellable?
    private var sendMessageRequest: Cancellable?
    private var handleEventReqeust: Cancellable?

    private var currentUserId: String {
        guard let id = userService.currentUserSubject.value?.id else { return "" }
        return id
    }
    private var messages: [ConversationMessageCellModel] = [] {
        didSet {
            sections = []
        }
    }
    private var storedMessagesIDs: [String] = []
    
    var sections: [ConversationMessageSection] = []
    
    init(view: ConversationViewProtocol,
         networkService: NetworkServiceProtocol,
         dataService: DataServiceProtocol,
         userService: UserServiceProtocol,
         channel: ChannelModel) {
        self.view = view
        self.networkService = networkService
        self.dataService = dataService
        self.userService = userService
        self.channel = channel
    }
    
    func viewDidDissapear() {
        messagesRequest = nil
        sendMessageRequest = nil
    }
    
    func viewDidLoad() {
        view?.setupChannel(name: channel.name, image: channel.logoURL)
        getMessagesFromCache { [weak self] in
            self?.fetchMessages()
        }
        handleEvents()
    }
    
    func sendMessage(text: String) throws {
        guard let user = userService.currentUserSubject.value,
              let name = user.name
        else { throw UserError.noUser }
        view?.showLoading()
        sendMessageRequest = networkService.createMessage(text: text, channelId: channel.id, userId: user.id, userName: name)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.handleError(completion: completion)
            }, receiveValue: { [weak self] message in
                guard let self else { return }
                self.dataService.saveMessage(with: message, in: self.channel)
                self.insertMessage(message: message)
                self.view?.setupDataSource()
            })
    }
    
    func getTitleFor(section: Int) -> String {
        let calendar = Calendar.current
        let currentDate = calendar.dateComponents([.day, .year], from: Date())
        let title = sections[section].title

        if let date = DateFormatterFactory.formatter(with: "MMM, d, yyyy").date(from: title) {
            let titleDate = calendar.dateComponents([.day, .year], from: date)

            if currentDate.year == titleDate.year {

                if calendar.isDateInToday(date) {
                    return "Today"
                }

                if calendar.isDateInYesterday(date) {
                    return "Yesterday"
                }

                return DateFormatterFactory.formatter(with: "MMM, d").string(from: date)
            }
        }
        return title
    }
    
    private func fetchMessages() {
        view?.showLoading()
        messagesRequest = networkService.getMessages(channelId: channel.id)
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.handleError(completion: completion)
            } receiveValue: { [weak self] messages in
                guard let self else { return }
                self.save(messages: messages)
                self.messages = self.getConversationMessageCells(messages: messages)
                self.createSections()
                self.view?.setupDataSource()
            }
    }
    
    private func handleEvents() {
        handleEventReqeust = networkService.handleEvents()
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { [weak self] event in
                switch event.eventType {
                case .update:
                    if event.resourceID == self?.channel.id {
                        self?.fetchMessages()
                    }
                case .add, .delete:
                    break
                }
            })
    }
    
    private func handleError(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            view?.showErrorAlert(message: error.localizedDescription)
        }
        view?.hideLoading()
    }
    
    private func createSections() {
        var dateTitlesSet: Set<String> = []
        let dateFormatter = DateFormatterFactory.formatter(with: "MMM, d, yyyy")

        for message in messages {
            dateTitlesSet.insert(dateFormatter.string(from: message.date))
        }
        
        let dateTitles = Array(dateTitlesSet).sorted(by: >)
        
        for date in dateTitles {
            let filteredMessages = messages.filter({ date == dateFormatter.string(from: $0.date) })
            let section = ConversationMessageSection(title: date, messages: filteredMessages)
            sections.append(section)
        }
    }

    private func getConversationMessageCells(messages: [MessageProtocol]) -> [ConversationMessageCellModel] {
        var previousId = ""
        var conversationMessages: [ConversationMessageCellModel] = []
        let messages = messages.filter { !$0.text.isEmptyOrOnlyWhitespaces }.sorted(by: { $0.date > $1.date })
    
        for i in 0..<messages.count {
            var model = ConversationMessageCellModel(message: messages[i], currentUserId: currentUserId)
            model.isLastMessage = model.userId != previousId
            previousId = model.userId
            
            if i < messages.count - 1 {
                model.isFirstMessage = model.userId != messages[i + 1].userID
            }

            conversationMessages.append(model)
        }
        
        return conversationMessages
    }
    
    private func insertMessage(message: MessageProtocol) {
        let dateFormatter = DateFormatterFactory.formatter(with: "MMM, d, yyyy")
        let messageDate = dateFormatter.string(from: message.date)
        let message = ConversationMessageCellModel(message: message, currentUserId: currentUserId)
        if let sectionIndex = sections.firstIndex(where: { $0.title == messageDate }) {
            sections[sectionIndex].messages.insert(message, at: 0)
        } else {
            sections.insert(ConversationMessageSection(title: messageDate, messages: [message]), at: 0)
        }
    }
    
    private func getMessagesFromCache(completion: @escaping () -> Void) {
        dataService.getMessages(for: channel.id) { [weak self] response in
            switch response {
            case .success(let messages):
                guard let self else { return }
                self.messages = self.getConversationMessageCells(messages: messages)
                self.storedMessagesIDs = messages.map { $0.id }
                self.createSections()
                self.view?.setupDataSource()
            case .failure(let error):
                self?.view?.showErrorAlert(message: error.localizedDescription)
            }
            completion()
        }
    }
    
    private func save(messages: [MessageProtocol]) {
        for message in messages {
            guard !storedMessagesIDs.contains(message.id) else { continue }
            dataService.saveMessage(with: message, in: channel)
        }
    }
}
