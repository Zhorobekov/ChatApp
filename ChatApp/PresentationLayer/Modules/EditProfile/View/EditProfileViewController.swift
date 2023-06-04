//
//  EditProfileViewController.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 03.05.2023.
//

import UIKit
import Combine

final class EditProfileViewController: BaseViewController {
    
    var presenter: EditProfilePresenterProtocol?

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.cancelButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var saveChangesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.showsMenuAsPrimaryAction = true
        button.isHidden = true
        return button
    }()
    private lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.layer.cornerRadius = 75
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.image = Constants.Profile.personImage
        return imageView
    }()
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.addPhotoButtonTitle, for: .normal)
        button.titleLabel?.font = Constants.Font.systemFont17
        button.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var editableNameView = EditableUserInfoView(title: Constants.Profile.editableNameTitle, placeholder: Constants.Profile.editableNamePlaceholder)
    private lazy var editableBioView = EditableUserInfoView(title: Constants.Profile.editableBioTitle, placeholder: Constants.Profile.editableBioPlaceholder)
    private lazy var editableUserInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [editableNameView, editableBioView])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        stackView.setupBorders(sides: [.top, .bottom])
        return stackView
    }()
    private lazy var alert = SelectImageAlertController(rootView: self)

    private var currentUser: User? {
        presenter?.currentUserSubject.value
    }
    
    private var userBind: Set<AnyCancellable> = []
    private lazy var editableStackViewTopAnchor = editableUserInfoStackView.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 24)

    private var isKeyboardShow = false {
        didSet {
            editableStackViewTopAnchor.constant = isKeyboardShow ? -24 : 24
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private var isImageDidChange = false {
        didSet {
            isUserEdited = isImageDidChange
        }
    }
    
    private var isUserEdited = false {
        didSet {
            saveChangesButton.isHidden = !isUserEdited
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.viewDidDisappear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
        setupEditableViewsCallback()
        updateEditState()
        presenter?.viewDidLoad()
    }
    
    private func bind() {
        presenter?.currentUserSubject
            .map { UIImage(data: $0?.avatarImage) ?? Constants.Profile.personImage }
            .assign(to: \.image, on: profileImageView)
            .store(in: &userBind)
    
        presenter?.currentUserSubject
            .map { $0?.name }
            .assign(to: \.text, on: editableNameView.textField)
            .store(in: &userBind)
        
        presenter?.currentUserSubject
            .map { $0?.bio }
            .assign(to: \.text, on: editableBioView.textField)
            .store(in: &userBind)
    }
    
    private func setupEditableViewsCallback() {
        editableNameView.callback = { [weak self] in
            self?.updateEditState()
        }

        editableBioView.callback = { [weak self] in
            self?.updateEditState()
        }
    }
    
    private func updateEditState() {
        let isNameEdit = editableNameView.textField.text != currentUser?.name ?? ""
        let isBioEdit = editableBioView.textField.text != currentUser?.bio ?? ""
        
        isUserEdited = isNameEdit || isBioEdit || isImageDidChange
    }
    
    private func showAlert(with title: String, message: String, isErrorAlert: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        if isErrorAlert {
            let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { [weak self] _ in
                guard let self else { return }
                self.presenter?.saveUser(name: self.editableNameView.textField.text,
                                         bio: self.editableBioView.textField.text,
                                         avatarImageData: self.profileImageView.image?.jpegData(compressionQuality: 1))
            }
            alert.addAction(tryAgainAction)
        }
        present(alert, animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        editableBioView.textFieldResignFirstResponder()
        editableNameView.textFieldResignFirstResponder()
        presenter?.cancelButtonTapped(completion: { [weak self] in
            self?.dismiss(animated: true)
        })
    }
    
    @objc private func saveButtonTapped() {
        if editableNameView.textField.text.isNilOrEmpty {
            showAlert(with: "Error", message: "Field name cannot be empty", isErrorAlert: false)
            return
        }
        
        let imageData = profileImageView.image == Constants.Profile.personImage
        ? nil
        : profileImageView.image?.jpegData(compressionQuality: 1)
    
        presenter?.saveUser(name: editableNameView.textField.text,
                            bio: editableBioView.textField.text,
                            avatarImageData: imageData)
    }
    
    @objc private func addPhotoButtonTapped() {
        present(alert, animated: true)
    }
    
    func getProFileImageViewFrame() -> CGRect {
        profileImageView.convert(profileImageView.bounds, to: view)
    }
}

// MARK: - Constraints

extension EditProfileViewController: EditProfileViewProtocol {
    func showLoading() {
        [editableNameView, editableBioView, addPhotoButton, saveChangesButton].forEach { $0.isUserInteractionEnabled = false }
        saveChangesButton.setTitle("", for: .normal)
        indicatorView.startAnimating()
    }
    
    func hideLoading() {
        indicatorView.stopAnimating()
        saveChangesButton.setTitle("Save", for: .normal)
        [editableNameView, editableBioView, addPhotoButton, saveChangesButton].forEach { $0.isUserInteractionEnabled = true }
    }
    
    func showAlert(isSaved: Bool, message: String) {
        let title = isSaved ? "Success" : "Could not save profile"
        showAlert(with: title, message: message, isErrorAlert: !isSaved)
    }
    
    func setNewAvatarImage(data: Data?) {
        let image = UIImage(data: data)
        profileImageView.image = image
        isImageDidChange = true
    }
    
    func finishEditing() {
        isImageDidChange = false
        isUserEdited = false 
    }
}

private extension EditProfileViewController {
   
    func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        setupTopNavigationConstraints()
        setupProfileImageView()
        setupAddPhotoButton()
        setupEditableUserInfoStackView()
        setupIndicatorView()
    }
    
    func setupTopNavigationConstraints() {
        title = Constants.navigationTitle
        let cancelButton = UIBarButtonItem(customView: cancelButton)
        let saveButton = UIBarButtonItem(customView: saveChangesButton)
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func setupProfileImageView() {
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, padding: UIEdgeInsets(top: 32), size: CGSize(width: 150, height: 150))
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupAddPhotoButton() {
        view.addSubview(addPhotoButton)
        addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addPhotoButton.anchor(top: profileImageView.bottomAnchor, padding: UIEdgeInsets(top: 24))
    }
    
    func setupEditableUserInfoStackView() {
        view.addSubview(editableUserInfoStackView)
        editableStackViewTopAnchor.isActive = true
        editableUserInfoStackView.anchor(top: addPhotoButton.bottomAnchor,
                                         leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 24))
    }
    
    func setupIndicatorView() {
        saveChangesButton.addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.centerYAnchor.constraint(equalTo: saveChangesButton.centerYAnchor),
            indicatorView.centerXAnchor.constraint(equalTo: saveChangesButton.centerXAnchor)
        ])
    }
}

private extension EditProfileViewController {
    func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        guard view.frame.height - editableUserInfoStackView.frame.maxY < keyboardHeight  else { return }
        isKeyboardShow = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard isKeyboardShow else { return }
        isKeyboardShow = false
    }
}

extension EditProfileViewController: SelectImageAlertProtocol {

    func localImageDidSet(image: UIImage?) {
        isImageDidChange = true
        profileImageView.image = image
    }
    
    func downloadImageTapped() {
        presenter?.downloadImageTapped()
    }
    
}
