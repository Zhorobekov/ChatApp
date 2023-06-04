//
//  PixabayService.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 28.04.2023.
//

import Foundation
import Combine

protocol PixabayServiceProtocol {
    func searchImages(query: String) -> AnyPublisher<[String], PixabayError>
}

final class PixabayService: PixabayServiceProtocol {
    
    private let apiKey: String = Bundle.main.object(forInfoDictionaryKey: "pixabayApi") as? String ?? ""
    private let imagesPerPage = 100
    
    func searchImages(query: String) -> AnyPublisher<[String], PixabayError> {
        guard var urlComponents = URLComponents(string: "https://pixabay.com/api/") else {
            return Fail(error: PixabayError.invalidURL).eraseToAnyPublisher()
        }
        let queryParameters = [
            "key": apiKey,
            "q": query,
            "per_page": String(imagesPerPage)
        ]
        urlComponents.queryItems = queryParameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        guard let url = urlComponents.url else {
            return Fail(error: PixabayError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { error in
                PixabayError.requestFailed(error)
            }
            .flatMap { data, response -> AnyPublisher<[String], PixabayError> in
                guard let httpResponse = response as? HTTPURLResponse else {
                    return Fail(error: PixabayError.invalidResponse).eraseToAnyPublisher()
                }
                if !(200...299).contains(httpResponse.statusCode) {
                    return Fail(error: PixabayError.invalidResponse).eraseToAnyPublisher()
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(PixabayResponse.self, from: data)
                    let webformatURLs = response.hits.map { $0.webformatURL }
                    return Just(webformatURLs).setFailureType(to: PixabayError.self).eraseToAnyPublisher()
                } catch {
                    return Fail(error: PixabayError.invalidData).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
