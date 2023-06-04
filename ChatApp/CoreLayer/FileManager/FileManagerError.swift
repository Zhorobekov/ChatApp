//
//  FileManagerError.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 19.04.2023.
//

import Foundation

enum FileManagerError: Error {
    case encodingError
    case invalidUserDataUrl
    case valueNotWrite
    case noData
}
