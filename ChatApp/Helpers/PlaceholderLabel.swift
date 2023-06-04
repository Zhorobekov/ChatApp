//
//  DefaultLabel.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 30.03.2023.
//

import UIKit

final class PlaceholderLabel: UILabel {
    
    private let placeholderText: String
    
    override var text: String? {
        didSet {
            super.text = text.isNilOrEmpty ? placeholderText : text
        }
    }

    init(placeholderText: String) {
        self.placeholderText = placeholderText
        super.init(frame: .zero)
        self.text = placeholderText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
