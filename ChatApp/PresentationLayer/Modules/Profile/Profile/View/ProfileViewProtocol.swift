//
//  ProfileViewProtocol.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 20.04.2023.
//

import Foundation

protocol ProfileViewProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
}
