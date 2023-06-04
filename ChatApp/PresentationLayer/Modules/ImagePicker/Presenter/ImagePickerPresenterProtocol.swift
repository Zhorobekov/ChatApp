//
//  ImagePickerPresenterProtocol.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 28.04.2023.
//

import Foundation

protocol ImagePickerPresenterProtocol {
    var imageUrls: [String] { get set }
    func viewDidLoad()
    func localImageDidChange(imageData: Data?, completion: () -> Void)
}
