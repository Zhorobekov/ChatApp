//
//  ImagePickerDelegate.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 03.05.2023.
//

import Foundation

protocol ImagePickerDelegate: AnyObject {
    func localImageDidChange(imageData: Data?)
}
