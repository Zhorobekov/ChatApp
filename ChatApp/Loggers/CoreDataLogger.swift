//
//  CoreDataLogger.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 12.04.2023.
//

import Foundation

protocol CoreDataLoggerProtocol {
    func messageSaved(messageID: String, isSaved: Bool)
    func messageNotSaved(messageID: String, reason: String)
    func outdatedChat(isDeleted: Bool)
    func getChannels(isReceived: Bool, count: Int)
    func getMessages(isReceived: Bool, count: Int)
    func channelWasSaved(with id: String, isSaved: Bool)
    func channelWasDeleted(with id: String, isDeleted: Bool, message: String)
}

final class CoreDataLoggerImpl: CoreDataLoggerProtocol {

    func messageSaved(messageID: String, isSaved: Bool) {
        printLog("CoreData: message with id: \(messageID) was saved: \(isSaved)")
    }
    
    func messageNotSaved(messageID: String, reason: String) {
        printLog("CoreData: message with id: \(messageID) not saved in CoreData, reason: \(reason)")
    }
    
    func outdatedChat(isDeleted: Bool) {
         printLog("CoreData: outdated chats was deleted: \(isDeleted)")
    }
    
    func getChannels(isReceived: Bool, count: Int) {
         printLog("CoreData: channels from core data was received: \(isReceived), count: \(count)")
    }
    
    func getMessages(isReceived: Bool, count: Int) {
         printLog("CoreData: channels from core data was received: \(isReceived), count: \(count)")
    }
    
    func channelWasSaved(with id: String, isSaved: Bool) {
           printLog("CoreData: channel ID: \(id), was saved: \(isSaved)")
    }
    
    func channelWasDeleted(with id: String, isDeleted: Bool, message: String) {
           printLog("CoreData: channel ID: \(id), was deleted: \(isDeleted), message: \(message)")
    }
    
    private func printLog(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
}
