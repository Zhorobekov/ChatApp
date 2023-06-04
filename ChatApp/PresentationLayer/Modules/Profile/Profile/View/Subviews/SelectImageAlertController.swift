//
//  SelectImageAlertController.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 27.02.2023.
//

import UIKit
import AVFoundation

protocol SelectImageAlertProtocol: AnyObject {
    func localImageDidSet(image: UIImage?)
    func downloadImageTapped()
}

final class SelectImageAlertController: UIAlertController {
    
    private weak var rootView: (UIViewController & SelectImageAlertProtocol)?

    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    
    init(rootView: UIViewController & SelectImageAlertProtocol) {
        self.rootView = rootView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
    
    private func setupButtons() {
        let closeAction = UIAlertAction(title: Constants.Alert.closeActionTitle, style: .cancel)
        
        let makePhotoAction = UIAlertAction(title: Constants.Alert.makePhotoActionTitle, style: .default) { [weak self] _ in
            self?.checkCameraAuthorizationStatus { haveAccess in
                DispatchQueue.main.async {
                    haveAccess ? self?.presentCamera() : self?.showCameraAccessAlert()
                }
            }
        }
    
        let chooseFromGalleryAction = UIAlertAction(title: Constants.Alert.chooseFromGalleryActionTitle, style: .default) { [weak self] _ in
            DispatchQueue.main.async { 
                self?.presentGallery()
            }
        }
        
        let downloadImageAction = UIAlertAction(title: Constants.Alert.download, style: .default) { [weak self] _ in
            DispatchQueue.main.async {
                self?.presentImagePicker()
            }
        }
        
        addAction(closeAction)
        addAction(makePhotoAction)
        addAction(chooseFromGalleryAction)
        addAction(downloadImageAction)
    }
    
    private func checkCameraAuthorizationStatus(completion: @escaping (Bool) -> Void ) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    private func showCameraAccessAlert() {
        let alertController = UIAlertController(
            title: Constants.Alert.cameraAccessAlertTitle,
            message: Constants.Alert.cameraAccessAlertMessage,
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: Constants.Alert.closeActionTitle, style: .cancel))
        alertController.addAction(UIAlertAction(title: Constants.Alert.settingsActionTitle, style: .default, handler: { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }))
        
        rootView?.present(alertController, animated: true)
    }
    
    private func presentCamera() {
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .front
        
        rootView?.present(imagePicker, animated: true)
    }
    
    private func presentGallery() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [UTType.image.identifier]
        
        rootView?.present(imagePicker, animated: true)
    }
    
    func presentImagePicker() {
        rootView?.downloadImageTapped()
    }
}

extension SelectImageAlertController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        picker.dismiss(animated: true) { [weak self] in
            self?.rootView?.localImageDidSet(image: image)
        }
    }
}
