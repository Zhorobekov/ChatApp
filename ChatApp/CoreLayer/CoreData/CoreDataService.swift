//
//  CoreDataService.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 12.04.2023.
//

import CoreData
import Foundation

enum CoreDataServiceError: String, Error {
    case noData = "channel to delete not found in context"
}

protocol CoreDataServiceProtocol {
    
    func fetchChannels() throws -> [DBChannelManagedObject]
    func fetchMessages(for channelID: String) throws -> [DBMessageManagedObject]
    func save(block: @escaping (NSManagedObjectContext) throws -> Void, completion: @escaping (Result<Void, Error>) -> Void)
    func removeOutdatedChats(activeChannelsIds: [String], completion: @escaping (Bool) -> Void)
    func deleteChannel(channel: ChannelModel, completion: @escaping (Result<Void, Error>) -> Void)
}

final class CoreDataService {

    private lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "Chat")
        persistentContainer.loadPersistentStores { _, error in
            guard let error else { return }
            print(error)
        }
        return persistentContainer
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}

extension CoreDataService: CoreDataServiceProtocol {

    func fetchChannels() throws -> [DBChannelManagedObject] {
        let fetchRequest = DBChannelManagedObject.fetchRequest()
        return try viewContext.fetch(fetchRequest)
    }
    
    func fetchMessages(for channelID: String) throws -> [DBMessageManagedObject] {
        let fetchRequest = DBChannelManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", channelID)
        let channelManagedObject = try viewContext.fetch(fetchRequest).first
        
        guard let channelManagedObject,
              let messagesManagedObject = channelManagedObject.messages?.array as? [DBMessageManagedObject]
        else { return [] }

        return messagesManagedObject
    }

    func save(block: @escaping (NSManagedObjectContext) throws -> Void, completion: @escaping (Result<Void, Error>) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.perform {
            do {
                try block(backgroundContext)
                if backgroundContext.hasChanges {
                    try backgroundContext.save()
                    completion(.success(()))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func removeOutdatedChats(activeChannelsIds: [String], completion: @escaping (Bool) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let fetchRequest = DBChannelManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "NOT id IN %@", activeChannelsIds)
    
        backgroundContext.perform {
            do {
                let channelsToDelete = try backgroundContext.fetch(fetchRequest)
                for channel in channelsToDelete {
                    backgroundContext.delete(channel)
                }
                try backgroundContext.save()
                completion(true)
            } catch {
                completion(false)
            }
        }
    }
    
    func deleteChannel(channel: ChannelModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let fetchRequest = DBChannelManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", channel.id as CVarArg)

        backgroundContext.perform {
            do {
                if let channelToDelete = try backgroundContext.fetch(fetchRequest).first {
                    backgroundContext.delete(channelToDelete)
                    try backgroundContext.save()
                    completion(.success(()))
                } else {
                    completion(.failure(CoreDataServiceError.noData))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
