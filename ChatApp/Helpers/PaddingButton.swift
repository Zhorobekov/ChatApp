//
//  PaddingButton.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 13.03.2023.
//

import UIKit

final class PaddingButton: UIButton {

    private let insets: UIEdgeInsets

    init(inset: CGFloat) {
        self.insets = UIEdgeInsets(top: -inset, left: -inset, bottom: -inset, right: -inset)
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.inset(by: insets).contains(point)
    }
}
