//
//  swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 19.04.2023.
//

import UIKit

final class TopNavigationBar: UIView {

    private lazy var blurEffectView: UIVisualEffectView = {
        let style: UIBlurEffect.Style = UITraitCollection.current.userInterfaceStyle == .light ? .light : .dark
        let blurEffect = UIBlurEffect(style: style)
        let visualEffect = UIVisualEffectView(effect: blurEffect)
        return visualEffect
    }()
    private lazy var avatarImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.layer.cornerRadius = Constants.Conversation.avatarImageViewSize.height / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemPink
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Conversation.nameLabelFont
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var backButton: PaddingButton = {
        let button = PaddingButton(inset: 12)
        button.setImage(Constants.Conversation.chevronImage, for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var navigationSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private let backButtonCallback: () -> Void
    
    init(backButtonCallback: @escaping () -> Void) {
        self.backButtonCallback = backButtonCallback
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(name: String, image: String?) {
        nameLabel.text = name
        setupAvatar(imageUrl: image, channelName: name)
    }
}

// MARK: - Private Methods

private extension TopNavigationBar {
    func setupAvatar(imageUrl: String?, channelName: String) {
        if let imageUrl {
            avatarImageView.backgroundColor = .clear
            avatarImageView.set(imageUrl: imageUrl, onError: { [weak self] in
                self?.setupInitials(channelName: channelName)
            })
        } else {
            setupInitials(channelName: channelName)
        }
    }
    
    func setupInitials(channelName: String) {
        avatarImageView.image = UIImage.getInitialsImage(fullName: channelName, size: CGSize(width: 45, height: 45))
        avatarImageView.backgroundColor = .systemPink
    }
    
    @objc private func backButtonTapped() {
        backButtonCallback()
    }
}

// MARK: - Constraints

private extension TopNavigationBar {
    func setupView() {
        backgroundColor = .navigationColor
        
        addSubview(blurEffectView)
        blurEffectView.fillSuperview()
        
        addSubview(avatarImageView)
        avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        avatarImageView.anchor(top: topAnchor,
                               padding: UIEdgeInsets(top: UIView.topSafeAreaInsets + 17),
                               size: CGSize(width: Constants.Conversation.avatarImageViewSize.width,
                                            height: Constants.Conversation.avatarImageViewSize.height))
        
        addSubview(nameLabel)
        nameLabel.anchor(top: avatarImageView.bottomAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor,
                         padding: UIEdgeInsets(top: 5, left: 16, bottom: 20, right: 16))
        
        addSubview(backButton)
        backButton.anchor(top: avatarImageView.centerYAnchor,
                          leading: leadingAnchor,
                          padding: UIEdgeInsets(left: 18),
                          size: CGSize(width: 20, height: 20))
        
        addSubview(navigationSeparatorView)
        navigationSeparatorView.anchor(leading: leadingAnchor,
                                       bottom: bottomAnchor,
                                       trailing: trailingAnchor,
                                       size: CGSize(width: 0, height: 1))
    }
}
