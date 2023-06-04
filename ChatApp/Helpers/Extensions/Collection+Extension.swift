//
//  Collection+Extension.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 20.04.2023.
//

import Foundation

extension Collection {
    subscript(safe i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }
}

extension Array {
    mutating func safeRemove(at index: Index) {
        guard self.indices.contains(index) else { return }
        self.remove(at: index)
    }
}
