//
//  MessageModel.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 12.04.2023.
//

import Foundation

protocol MessageProtocol {
    var id: String { get }
    var text: String { get }
    var userID: String { get }
    var userName: String { get }
    var date: Date { get }
}

struct MessageModel: MessageProtocol, Hashable {
    let id: String
    let text: String
    let userID: String
    let userName: String
    let date: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MessageModel, rhs: MessageModel) -> Bool {
        lhs.id == rhs.id
        && lhs.text == rhs.text
        && lhs.userID == rhs.userID
        && lhs.date == rhs.date
    }
}
