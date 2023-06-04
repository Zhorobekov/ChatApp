//
//  ChatsPresenter.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 07.03.2023.
//

import UIKit
import Combine

final class ConversationsListPresenter: ConversationsListPresenterProtocol {
    
    private weak var view: ConversationsListViewProtocol?
    private let fileManager: FileServiceProtocol
    private let networkService: NetworkServiceProtocol
    private let dataService: DataServiceProtocol
    private let userService: UserServiceProtocol
    private let themeService: ThemeServiceProtocol
    private weak var output: ConversationsListPresenterOutput?
    
    private var channelRequests: Set<AnyCancellable> = []
    private var userRequest: Cancellable?
    
    private var storedChannels: [ChannelModel] = []
    
    var channels: [ChannelModel] = []
    var currentTheme: UIUserInterfaceStyle {
        themeService.currentTheme
    }
    
    init(view: ConversationsListViewProtocol?,
         fileManager: FileServiceProtocol,
         networkService: NetworkServiceProtocol,
         dataService: DataServiceProtocol,
         themeService: ThemeServiceProtocol,
         userService: UserServiceProtocol,
         output: ConversationsListPresenterOutput?
    ) {
        self.view = view
        self.fileManager = fileManager
        self.networkService = networkService
        self.dataService = dataService
        self.themeService = themeService
        self.userService = userService
        self.output = output
    }
    
    func viewDidLoad() {
        getUser()
        fetchChannelsFromCache()
        handleEvents()
    }
    
    func didSelectRowAt(at index: Int) {
        guard let channel = channels[safe: index] else { return }
        output?.moduleWantsToOpenConversation(with: channel)
    }
    
    func deleteChannel(at index: Int) {
        guard let channelId = channels[safe: index]?.id else { return }
        networkService.deleteChannel(with: channelId)
            .subscribe(on: DispatchQueue.global(qos: .unspecified))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.removeChannel(with: channelId)
                case .failure(let error):
                    self?.view?.reloadData()
                    self?.view?.showErrorAlert(message: error.localizedDescription)
                }
            }, receiveValue: { }).store(in: &channelRequests)
    }
    
    func getChannels() {
        networkService.getChannels()
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.handleError(completion: completion)
            }, receiveValue: { [weak self] channels in
                guard let self else { return }
                self.channels = channels.sorted(by: { $0.lastActivity ?? Date(timeIntervalSince1970: .zero)
                    > $1.lastActivity ?? Date(timeIntervalSince1970: .zero) })
                .map { ChannelModel(channel: $0) }
                self.save(channels: self.channels)
                self.view?.hideLoading()
                self.view?.reloadData()
            }).store(in: &channelRequests)
    }
    
    func createChannel(name: String?) {
        guard let name else { return }
        view?.showLoading()
        networkService.createChannel(name: name)
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.handleError(completion: completion)
            }, receiveValue: { [weak self] channel in
                let channel = ChannelModel(channel: channel)
                self?.dataService.saveChannel(with: channel) { result in
                    switch result {
                    case .success:
                        self?.channels.insert(channel, at: 0)
                        self?.view?.hideLoading()
                        self?.view?.reloadData()
                    case .failure(let error):
                        self?.view?.showErrorAlert(message: error.localizedDescription)
                    }
                }
            }).store(in: &channelRequests)
    }
    
    private func removeChannel(with id: String) {
        guard let index = channels.firstIndex(where: { $0.id == id }), let channel = channels[safe: index] else { return }
        dataService.delete(channel: channel) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.channels.safeRemove(at: index)
            case .failure(let error):
                self.view?.showErrorAlert(message: error.localizedDescription)
            }
            self.view?.reloadData()
        }

    }
    
    private func handleEvents() {
         networkService.handleEvents()
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { [weak self] event in
                switch event.eventType {
                case .add, .update:
                    self?.getChannels()
                case .delete:
                    self?.removeChannel(with: event.resourceID)
                }
            }).store(in: &channelRequests)
    }
    
    private func handleError(completion: Subscribers.Completion<Error>) {
        self.view?.hideLoading()
        switch completion {
        case .finished:
            break
        case .failure(let error):
            view?.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    private func fetchChannelsFromCache() {
        let cachedChannels = dataService.getChannels()
        storedChannels = cachedChannels
        channels = cachedChannels.sorted(by: { $0.lastActivity ?? Date(timeIntervalSince1970: .zero)
            > $1.lastActivity ?? Date(timeIntervalSince1970: .zero) })
        view?.reloadData()
    }
    
    private func save(channels: [ChannelModel]) {
        for channel in channels {
            guard !storedChannels.contains(channel) else { continue }
            dataService.saveChannel(with: channel) { [weak self] result in
                switch result {
                case .success:
                    self?.storedChannels.append(channel)
                case .failure(let error):
                    self?.view?.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
        dataService.removeOutdatedChats(activeChannelsIds: channels.map { $0.id })
    }
    
    private func getUser() {
        userRequest = fileManager.getUser()
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] user in
                self?.userService.setUserSubject(user: user)
            })
    }
}
