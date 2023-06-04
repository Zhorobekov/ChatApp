//
//  PixabayError.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 28.04.2023.
//

import Foundation

enum PixabayError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case invalidData
}
