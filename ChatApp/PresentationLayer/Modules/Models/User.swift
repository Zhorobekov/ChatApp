//
//  User.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 06.03.2023.
//

import UIKit

struct User: Codable {
    var id: String
    let name: String?
    let bio: String?
    var avatarImage: Data?
    
    init(id: String, name: String?, bio: String?, avatarImage: Data? = nil) {
        self.id = id
        self.name = name
        self.bio = bio
        self.avatarImage = avatarImage
    }
}
