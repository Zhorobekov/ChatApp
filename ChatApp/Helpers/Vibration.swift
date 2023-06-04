//
//  Vibrate.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 13.03.2023.
//

import UIKit

final class Vibration {
    static func vibrate() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
