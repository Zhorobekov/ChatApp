//
//  WebImageView.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 04.04.2023.
//

import UIKit

final class WebImageView: UIImageView {
    
    private var currentUrlString: String?
    
    func set(imageUrl: String?, onError: @escaping () -> Void) {
        
        self.contentMode = .scaleAspectFill
        
        currentUrlString = imageUrl
        
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {
            self.image = nil
            onError()
            return
        }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, _) in
           
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self?.handleLoadedImage(data: data, response: response, onError: onError)
                } else {
                    onError()
                }
            }
        }
        dataTask.resume()
    }
    
    private func handleLoadedImage(data: Data, response: URLResponse, onError: @escaping () -> Void) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
        
        if responseURL.absoluteString == currentUrlString {
            guard let image = UIImage(data: data) else {
                onError()
                return
            }
            self.image = image
            return
        }
        onError()
    }
}
