//
//  SendField.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 08.03.2023.
//

import UIKit

final class SendField: UITextField {
    
    private let padding = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
