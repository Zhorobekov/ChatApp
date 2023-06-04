//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 02.05.2023.
//

import UIKit
import UniformTypeIdentifiers
import Combine

final class ProfileViewController: BaseViewController {
    
    var presenter: ProfilePresenterProtocol?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 75
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.accessibilityIdentifier = "profileImageView"
        return imageView
    }()
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.addPhotoButtonTitle, for: .normal)
        button.titleLabel?.font = Constants.Font.systemFont17
        button.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var nameLabel: PlaceholderLabel = {
        let label = PlaceholderLabel(placeholderText: Constants.Profile.nameLabelDefaultValue)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = Constants.Font.systemBold22
        label.accessibilityIdentifier = "nameLabel"
        return label
    }()
    private lazy var descriptionLabel: PlaceholderLabel = {
        let label = PlaceholderLabel(placeholderText: Constants.Profile.descriptionLabelDefaultValue)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = Constants.Font.systemFont17
        label.textColor = .systemGray
        return label
    }()
    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 14
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.clipsToBounds = false
        view.layer.cornerRadius = 10
        return view
    }()
    private lazy var alert = SelectImageAlertController(rootView: self)
    private lazy var transitionManager: TransitionManager = {
        let transitionManager = TransitionManager()
        let absoluteFrame = profileImageView.convert(profileImageView.bounds, to: view)
        transitionManager.image = profileImageView.image
        transitionManager.startFrame = absoluteFrame
        return transitionManager
    }()

    private var isEditButtonAnimated = false {
        didSet {
            if isEditButtonAnimated {
                editButton.startShakeAnimation()
            } else {
                editButton.stopShakeAnimation()
            }
        }
    }
    
    private var userBind: Set<AnyCancellable> = []
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isEditButtonAnimated = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupLongTap()
        bind()
    }
    
    private func setupNavigationBar() {
        title = Constants.Profile.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupLongTap() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(editButtonLongTap))
        editButton.addGestureRecognizer(longPressGesture)
    }
    
    private func bind() {
        presenter?.currentUserSubject
            .map { $0?.name }
            .assign(to: \.text, on: nameLabel)
            .store(in: &userBind)
        
        presenter?.currentUserSubject
            .map { $0?.bio }
            .assign(to: \.text, on: descriptionLabel)
            .store(in: &userBind)
        
        presenter?.currentUserSubject
            .map { UIImage(data: $0?.avatarImage) ?? Constants.Profile.personImage }
            .assign(to: \.image, on: profileImageView)
            .store(in: &userBind)
    }
    
    @objc private func addPhotoButtonTapped() {
        present(alert, animated: true)
    }
    
    @objc private func editButtonTapped() {
        presenter?.editButtonTapped(transitionDelegate: self)
    }

    @objc func editButtonLongTap(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            isEditButtonAnimated.toggle()
        default:
            break
        }
    }
}

// MARK: - Constraints

private extension ProfileViewController {
    
    func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        setupContainerView()
        setupProfileImageView()
        setupAddPhotoButton()
        setupUserInfoStackView()
        setupEditButton()
    }
    
    func setupContainerView() {
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             padding: UIEdgeInsets(top: 16, left: 16, right: 16))
    }
    
    func setupProfileImageView() {
        containerView.addSubview(profileImageView)
        profileImageView.anchor(top: containerView.topAnchor,
                                padding: UIEdgeInsets(top: 32),
                                size: CGSize(width: 150, height: 150))
        profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    }
    
    func setupAddPhotoButton() {
        containerView.addSubview(addPhotoButton)
        addPhotoButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        addPhotoButton.anchor(top: profileImageView.bottomAnchor,
                              padding: UIEdgeInsets(top: 24))
    }
    
    func setupUserInfoStackView() {
        containerView.addSubview(userInfoStackView)
        userInfoStackView.anchor(top: addPhotoButton.bottomAnchor,
                                 leading: containerView.leadingAnchor,
                                 trailing: containerView.trailingAnchor,
                                 padding: UIEdgeInsets(top: 24, left: 16, bottom: 16, right: 16))
    }
    
    func setupEditButton() {
        containerView.addSubview(editButton)
        editButton.anchor(top: userInfoStackView.bottomAnchor,
                          leading: containerView.leadingAnchor,
                          bottom: containerView.bottomAnchor,
                          trailing: containerView.trailingAnchor,
                          padding: UIEdgeInsets(top: 24, left: 16, bottom: 16, right: 16),
                          size: CGSize(width: 0, height: 50))
    }
}

// MARK: - Image picker

extension ProfileViewController: SelectImageAlertProtocol {
    func localImageDidSet(image: UIImage?) {
        let imageData = image?.jpegData(compressionQuality: 1)
        presenter?.avatarImageDidChange(imageData: imageData, transitionDelegate: self)
    }
    
    func downloadImageTapped() {
        presenter?.downloadImageTapped()
    }
}

extension ProfileViewController: ProfileViewProtocol {
    
}

extension ProfileViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionManager.transitionType = .present
        return transitionManager
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionManager.transitionType = .dismiss
        transitionManager.image = profileImageView.image
        return transitionManager
    }
}
