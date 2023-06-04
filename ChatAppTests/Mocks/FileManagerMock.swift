//
//  FileManagerMock.swift
//  ChatAppTests
//
//  Created by Эрмек Жоробеков on 10.05.2023.
//

import Combine
@testable import ChatApp

final class FileManagerMock: FileManagerProtocol {

    var invokedSaveUser = false
    var invokedSaveUserCount = 0
    var invokedSaveUserParameters: (userPublisher: Just<User>, Void)?
    var invokedSaveUserParametersList = [(userPublisher: Just<User>, Void)]()
    var stubbedSaveUserCompletionResult: (Bool, Void)?

    func saveUser(userPublisher: Just<User>, completion: @escaping (Bool) -> Void) {
        invokedSaveUser = true
        invokedSaveUserCount += 1
        invokedSaveUserParameters = (userPublisher, ())
        invokedSaveUserParametersList.append((userPublisher, ()))
        if let result = stubbedSaveUserCompletionResult {
            completion(result.0)
        }
    }

    var invokedGetUser = false
    var invokedGetUserCount = 0
    var stubbedGetUserCompletionResult: (Result<User, Error>, Void)?

    func getUser(completion: @escaping (Result<User, Error>) -> Void) {
        invokedGetUser = true
        invokedGetUserCount += 1
        if let result = stubbedGetUserCompletionResult {
            completion(result.0)
        }
    }
}
