//
//  UIImage+Extension.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 06.03.2023.
//

import UIKit

extension UIImage {
        
    static func getInitialsImage(fullName: String, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        var font = UIFont.systemFont(ofSize: size.height * 0.5, weight: .medium)
        
        if let descriptor = font.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: font.pointSize)
        }

        let img = renderer.image { _ in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attrs: [NSAttributedString.Key: Any] = [
                .font: font,
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.white
            ]
            let nameArray = fullName.components(separatedBy: " ")
            var initials = String(nameArray.first?.first ?? " ")

            if nameArray.count > 1 {
                initials += String(nameArray.last?.first ?? " ")
            }
            
            let attributedString = NSAttributedString(string: initials.uppercased(), attributes: attrs)
            attributedString.draw(with: CGRect(x: 0, y: size.height / 2 - font.lineHeight / 2, width: size.width, height: size.height),
                                  options: .usesLineFragmentOrigin, context: nil)
        }

        return img
    }
    
    convenience init?(data: Data?) {
        guard let data else { return nil }
        self.init(data: data)
    }
}
