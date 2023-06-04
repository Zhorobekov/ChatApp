//
//  dataService.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 21.03.2023.
//

import Foundation
import Combine

final class FileService: FileServiceProtocol {
    
    private let fileManager: FileManagerProtocol
    private let queue = DispatchQueue.global(qos: .userInteractive)
    
    init(fileManager: FileManagerProtocol) {
        self.fileManager = fileManager
    }
   
    func saveUser(_ user: User) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future { [weak self] promise in
                self?.queue.async {
                    self?.fileManager.saveUser(userPublisher: Just(user), completion: { isSaved in
                        if isSaved {
                            promise(.success(true))
                        } else {
                            promise(.failure(FileServiceError.saveError))
                        }
                    })
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getUser() -> Future<User, Error> {
            Future { [weak self] promise in
                self?.queue.async {
                    self?.fileManager.getUser(completion: { result in
                        switch result {
                        case .success(let user):
                            promise(.success(user))
                        case .failure:
                            promise(.failure(FileServiceError.noUserFile))
                        }
                    })
                }
            }
    }
}
