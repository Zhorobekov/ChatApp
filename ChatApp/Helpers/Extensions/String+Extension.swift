//
//  String+Extension.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 23.03.2023.
//

import Foundation

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

extension String {
    var isEmptyOrOnlyWhitespaces: Bool {
        if self.isEmpty {
            return true
        } else {
            return self.filter({ $0 != " " }).isEmpty
        }
    }
}
