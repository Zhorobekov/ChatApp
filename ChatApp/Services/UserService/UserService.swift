//
//  UserManager.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 29.03.2023.
//

import Combine

protocol UserServiceProtocol {
    var currentUserSubject: CurrentValueSubject<User?, Never> { get }
    func setUserSubject(user: User?)
}

final class UserService: UserServiceProtocol {
        
    var currentUserSubject: CurrentValueSubject<User?, Never> = CurrentValueSubject(nil)
    
    func setUserSubject(user: User?) {
        currentUserSubject.send(user)
    }
}
