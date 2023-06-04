//
//  FileManagerProtocol.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 19.04.2023.
//

import Foundation
import Combine

protocol FileManagerProtocol {
    func saveUser(userPublisher: Just<User>, completion: @escaping (Bool) -> Void)
    func getUser(completion: @escaping (Result<User, Error>) -> Void)
}
