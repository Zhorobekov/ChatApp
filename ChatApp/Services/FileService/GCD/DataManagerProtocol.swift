//
//  DataManager.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 21.03.2023.
//

import Foundation

protocol DataManagerProtocol {
    func saveUser(changedInfo: [UserInfoType?], user: User, completion: @escaping (Bool) -> Void)
    func getUser(completion: @escaping (Result<User?, Error>) -> Void)
}

final class DataManager: DataManagerProtocol {
    
    private let fileManager = ChatFileManager()
    private let queue = DispatchQueue(label: "com.example.datamanager", attributes: .concurrent)
   
    func saveUser(changedInfo: [UserInfoType?], user: User, completion: @escaping (Bool) -> Void) {
        queue.async(flags: .barrier) { [weak self] in
            self?.fileManager.saveUser(changedInfo: changedInfo, user: user, completion: completion)
        }
    }
    
    func getUser(completion: @escaping (Result<User?, Error>) -> Void) {
        queue.async { [weak self] in
            self?.fileManager.getUser(completion: completion)
        }
    }
}
