//
//  ConversationCell.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 07.03.2023.
//

import UIKit

protocol ConfigurableViewProtocol {
    associatedtype ConfigurationModel
    static var reuseId: String { get }
    func configure(with model: ConfigurationModel)
}

final class ConversationCell: UITableViewCell, ConfigurableViewProtocol {
   
    typealias ConfigurationModel = ChannelModel
    static var reuseId = String(describing: ConversationCell.self)
    
    private lazy var avatarImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.layer.cornerRadius = 45 / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemPink
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .separator
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    private lazy var containerView = UIView()
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .separator
        return separator
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        avatarImageView.backgroundColor = .clear
        dateLabel.text = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMessage(_ message: String?) {
        if message.isNilOrEmpty {
            messageLabel.font = UIFont.italicSystemFont(ofSize: 15)
            messageLabel.text = "No messages yet"
        } else {
            messageLabel.font = UIFont.systemFont(ofSize: 15)
            messageLabel.text = message
        }
    }

    private func setupDate(_ date: Date?) {
        guard let date else { return }

        let calendar = Calendar.current
        let dateFormatter = DateFormatterFactory.formatter(with: calendar.isDateInToday(date) ? "HH:mm" : "dd MMMM")
        let stringDate = dateFormatter.string(from: date)
    
        dateLabel.text = stringDate
    }
    
    private func setupAvatar(imageUrl: String?, channelName: String) {
        if let imageUrl, !imageUrl.isEmpty, imageUrl.contains("http") {
            avatarImageView.set(imageUrl: imageUrl, onError: { [weak self] in
                self?.setupInitials(channelName: channelName)
            })
        } else {
            setupInitials(channelName: channelName)
        }
    }
    
    private func setupInitials(channelName: String) {
        avatarImageView.image = UIImage.getInitialsImage(fullName: channelName, size: CGSize(width: 45, height: 45))
        avatarImageView.backgroundColor = .systemPink
    }
    
    func configure(with model: ChannelModel) {
        nameLabel.text = model.name
        setupMessage(model.lastMessage)
        setupDate(model.lastActivity)
        setupAvatar(imageUrl: model.logoURL, channelName: model.name)
    }
}

// MARK: - Constraints

private extension ConversationCell {
    func setupViews() {
        setupContainerView()
        setupAvatarImageView()
        setupArrowImageView()
        setupDateLabel()
        setupNameLabel()
        setupMessageLabel()
        setupSeparator()
    }
    
    func setupContainerView() {
        contentView.addSubview(containerView)
        containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 45 + Constants.ConversationCell.containerTopPadding).isActive = true
        containerView.fillSuperview(padding: UIEdgeInsets(top: Constants.ConversationCell.containerTopPadding, bottom: 2))
    }
    
    func setupAvatarImageView() {
        containerView.addSubview(avatarImageView)
        avatarImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        avatarImageView.anchor(leading: containerView.leadingAnchor,
                               padding: UIEdgeInsets(left: 16),
                               size: CGSize(width: 45, height: 45))
    }

    func setupArrowImageView() {
        containerView.addSubview(arrowImageView)
        arrowImageView.anchor(top: containerView.topAnchor,
                              trailing: containerView.trailingAnchor,
                              padding: UIEdgeInsets(right: 16),
                              size: CGSize(width: 16, height: 16))
    }
    
    func setupDateLabel() {
        containerView.addSubview(dateLabel)
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        dateLabel.anchor(top: containerView.topAnchor,
                         trailing: arrowImageView.leadingAnchor,
                         padding: UIEdgeInsets(right: 8))
    }
    
    func setupNameLabel() {
        containerView.addSubview(nameLabel)
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        nameLabel.anchor(top: containerView.topAnchor,
                         leading: avatarImageView.trailingAnchor,
                         trailing: dateLabel.leadingAnchor,
                         padding: UIEdgeInsets(left: 12, right: 4))
    }
    
    func setupMessageLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        messageLabel.anchor(top: nameLabel.bottomAnchor,
                            leading: avatarImageView.trailingAnchor,
                            bottom: containerView.bottomAnchor,
                            trailing: arrowImageView.leadingAnchor, padding: UIEdgeInsets(left: 12, bottom: 15.5))
    }
    
    func setupSeparator() {
        contentView.addSubview(separator)
        separator.anchor(leading: messageLabel.leadingAnchor,
                         bottom: contentView.bottomAnchor,
                         trailing: contentView.trailingAnchor,
                         size: CGSize(width: 0, height: 1))
    }
}
