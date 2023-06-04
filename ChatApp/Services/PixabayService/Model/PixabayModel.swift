//
//  PixabayModel.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 28.04.2023.
//

import Foundation

struct PixabayResponse: Codable {
    let hits: [PixabayImage]
}

struct PixabayImage: Codable {
    let webformatURL: String
}
