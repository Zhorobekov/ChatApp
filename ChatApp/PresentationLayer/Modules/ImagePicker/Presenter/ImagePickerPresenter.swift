//
//  ImagePickerPresenter.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 28.04.2023.
//

import Foundation
import Combine

final class ImagePickerPresenter: ImagePickerPresenterProtocol {
    
    private weak var view: ImagePickerViewProtocol?
    private let pixabayService: PixabayServiceProtocol
    private let userService: UserServiceProtocol
    private weak var imagePickerDelegate: ImagePickerDelegate?

    private var imageUrlsRequest: Cancellable?
    private var imageRequests = Set<AnyCancellable>()
    private var currentUserSubject: CurrentValueSubject<User?, Never> {
        userService.currentUserSubject
    }
    
    var imageUrls: [String] = []
    
    init(view: ImagePickerViewProtocol,
         pixabayService: PixabayServiceProtocol,
         userService: UserServiceProtocol,
         imagePickerDelegate: ImagePickerDelegate?) {
        self.view = view
        self.pixabayService = pixabayService
        self.userService = userService
        self.imagePickerDelegate = imagePickerDelegate
    }
    
    func viewDidLoad() {
       fetchImageUrls()
    }

    private func fetchImageUrls() {
        view?.showLoading()
        imageUrlsRequest = pixabayService.searchImages(query: "car")
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.view?.showErrorAlert(message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] imageUrls in
                self?.view?.hideLoading()
                self?.imageUrls = imageUrls
                self?.view?.reloadData()
            })
    }
    
    func localImageDidChange(imageData: Data?, completion: () -> Void) {
        completion()
        imagePickerDelegate?.localImageDidChange(imageData: imageData)
    }
}
