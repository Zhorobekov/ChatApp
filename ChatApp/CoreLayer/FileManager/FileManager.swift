//
//  FileManager.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 23.03.2023.
//

import Foundation
import Combine

final class ChatFileManager {

    private let userJsonFileName = "user.json"
    private lazy var userDataUrl = FileManager.default.urls(for: .documentationDirectory, in: .userDomainMask).first?.appendingPathExtension(userJsonFileName)
    private var userSaveRequest: Cancellable?
    private var userGetRequest: Cancellable?
}

extension ChatFileManager: FileManagerProtocol {
    func saveUser(userPublisher: Just<User>, completion: @escaping (Bool) -> Void) {
        guard let userDataUrl else {
            completion(false)
            return
        }
        let encoder = JSONEncoder()
        userSaveRequest = userPublisher
            .encode(encoder: encoder)
            .tryMap { data in
                try? data.write(to: userDataUrl)
            }
            .sink(receiveCompletion: { [weak self] resultCompletion in
                switch resultCompletion {
                case .finished:
                    completion(true)
                case .failure:
                    completion(false)
                }
                self?.userSaveRequest = nil
            }, receiveValue: { })
    }
    
    func getUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let userDataUrl else {
            completion(.failure(FileManagerError.invalidUserDataUrl))
            return
        }
    
        let publisher = URLSession.shared.dataTaskPublisher(for: userDataUrl)
        let decoder = JSONDecoder()

        userGetRequest = publisher
            .map { $0.data }
            .decode(type: User.self, decoder: decoder)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    completion(.failure(error))
                }
                self?.userGetRequest = nil
            }, receiveValue: { user in
                completion(.success(user))
            })
    }
}
