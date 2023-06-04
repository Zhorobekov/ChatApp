//
//  dataServiceProtocol.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 19.04.2023.
//

import Combine

protocol FileServiceProtocol {
    func saveUser(_ user: User) -> AnyPublisher<Bool, Error>
    func getUser() -> Future<User, Error>
}
