//
//  ImageLoaderService.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 28.04.2023.
//

import Foundation
import UIKit
import Combine

protocol ImageLoaderProtocol {
    func searchImages(query: String) -> AnyPublisher<[String], PixabayError>
}

final class ImageLoader: ImageLoaderProtocol {
    
    private let pixabayService: PixabayServiceProtocol
    private static let cache = URLCache(
        memoryCapacity: 100 * 1024 * 1024, // 100 MB
        diskCapacity: 100 * 1024 * 1024, // 100 MB
        diskPath: "imageCache"
    )
    
    init(pixabayService: PixabayServiceProtocol) {
        self.pixabayService = pixabayService
    }
    
    func searchImages(query: String) -> AnyPublisher<[String], PixabayError> {
        pixabayService.searchImages(query: query)
    }
}
