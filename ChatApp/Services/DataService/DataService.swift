//
//  ChatDataSource.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 12.04.2023.
//

import Foundation

protocol DataServiceProtocol {
    
    func getChannels() -> [ChannelModel]
    func saveChannel(with channelCellModel: ChannelModel, completion: @escaping (Result<Void, Error>) -> Void)
    func getMessages(for channelID: String, completion: @escaping (Result<[MessageModel], Error>) -> Void)
    func saveMessage(with message: MessageProtocol, in channel: ChannelModel)
    func removeOutdatedChats(activeChannelsIds: [String])
    func delete(channel: ChannelModel, completion: @escaping (Result<Void, Error>) -> Void)
}

final class DataService {
    let coreDataService: CoreDataServiceProtocol
    let logger: CoreDataLoggerProtocol?
    
    init(coreDataService: CoreDataServiceProtocol, logger: CoreDataLoggerProtocol? = nil) {
        self.coreDataService = coreDataService
        self.logger = logger
    }
}

extension DataService: DataServiceProtocol {
    
    func getChannels() -> [ChannelModel] {
        do {
            let channelsManagedObject = try coreDataService.fetchChannels()
            let channels: [ChannelModel] = channelsManagedObject.compactMap { channelManagedObject in
                guard
                    let id = channelManagedObject.id,
                    let name = channelManagedObject.name
                else { return nil }
                return ChannelModel(id: id,
                                    name: name,
                                    logoURL: channelManagedObject.logoURL,
                                    lastMessage: channelManagedObject.lastMessage,
                                    lastActivity: channelManagedObject.lastActivity)
            }
            logger?.getChannels(isReceived: true, count: channels.count)
            return channels
        } catch {
            logger?.getChannels(isReceived: false, count: 0)
            return []
        }
    }

    func saveChannel(with channelCellModel: ChannelModel, completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataService.save { context in
            let channelManagedObject = DBChannelManagedObject(context: context)
            channelManagedObject.id = channelCellModel.id
            channelManagedObject.name = channelCellModel.name
            channelManagedObject.logoURL = channelCellModel.logoURL
            channelManagedObject.lastMessage = channelCellModel.lastMessage
            channelManagedObject.lastActivity = channelCellModel.lastActivity
            channelManagedObject.messages = NSOrderedSet()
        } completion: { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    completion(.success(()))
                }
                self?.logger?.channelWasSaved(with: channelCellModel.id, isSaved: true)
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                self?.logger?.channelWasSaved(with: channelCellModel.id, isSaved: false)
            }
        }
    }
    
    func getMessages(for channelID: String, completion: @escaping (Result<[MessageModel], Error>) -> Void) {
        do {
            let messagesManagedObjects = try coreDataService.fetchMessages(for: channelID)
            let messages: [MessageModel] = messagesManagedObjects.compactMap { messageManagedObject in
                guard
                    let id = messageManagedObject.id,
                    let text = messageManagedObject.text,
                    let userID = messageManagedObject.userID,
                    let userName = messageManagedObject.userName,
                    let date = messageManagedObject.date
                else { return nil }

                return MessageModel(id: id,
                                    text: text,
                                    userID: userID,
                                    userName: userName,
                                    date: date)
            }
            logger?.getMessages(isReceived: true, count: messages.count)
            DispatchQueue.main.async {
                completion(.success(messages))
            }
        } catch {
            logger?.getMessages(isReceived: false, count: 0)
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
    func saveMessage(with message: MessageProtocol, in channel: ChannelModel) {
        coreDataService.save { [weak self] context in
            let fetchRequest = DBChannelManagedObject.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", channel.id as CVarArg)
            let channelManagedObject = try context.fetch(fetchRequest).first
            
            guard
                let channelManagedObject
            else {
                self?.logger?.messageNotSaved(messageID: message.id, reason: "channel with ID: \(channel.id) not found")
                return
            }

            let messageManagedObject = DBMessageManagedObject(context: context)
            messageManagedObject.id = message.id
            messageManagedObject.text = message.text
            messageManagedObject.userID = message.userID
            messageManagedObject.userName = message.userName
            messageManagedObject.date = message.date
            channelManagedObject.addToMessages(messageManagedObject)
        } completion: { [weak self] result in
            switch result {
            case .success:
                self?.logger?.messageSaved(messageID: message.id, isSaved: true)
            case .failure:
                self?.logger?.messageSaved(messageID: message.id, isSaved: false)
            }
        }
    }
    
    func removeOutdatedChats(activeChannelsIds: [String]) {
        coreDataService.removeOutdatedChats(activeChannelsIds: activeChannelsIds) { [ weak self ] isDeleted in
            self?.logger?.outdatedChat(isDeleted: isDeleted)
        }
    }
    
    func delete(channel: ChannelModel, completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataService.deleteChannel(channel: channel) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    completion(.success(()))
                }
                self?.logger?.channelWasDeleted(with: channel.id, isDeleted: true, message: "")
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))                    
                }
                self?.logger?.channelWasDeleted(with: channel.id, isDeleted: false, message: error.localizedDescription)
            }
        }
    }
}
