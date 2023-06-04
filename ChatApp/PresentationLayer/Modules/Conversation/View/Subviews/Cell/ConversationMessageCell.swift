//
//  ConversationMessageCell.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 08.03.2023.
//

import UIKit

final class ConversationMessageCell: UITableViewCell, ConfigurableViewProtocol {
    
    static var reuseId = String(describing: ConversationMessageCell.self)
    typealias ConfigurationModel = ConversationMessageCellModel
    
    private lazy var containerView = UIView()
    private lazy var messageLabel = UILabel()
    private lazy var leftTailImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "tailLeft")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = .containerGray
        imageView.isHidden = true
        return imageView
    }()
    private lazy var rightTailImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "tailRight")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = .systemBlue
        imageView.isHidden = true
        return imageView
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    private lazy var containerViewLeadingAnchor = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
    private lazy var containerViewTrailingAnchor = containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
    private lazy var nameLabelTopAnchor = nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        leftTailImageView.isHidden = true
        rightTailImageView.isHidden = true
        containerViewLeadingAnchor.isActive = false
        containerViewTrailingAnchor.isActive = false
        nameLabelTopAnchor.constant = 0
        nameLabel.text = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func get(date: Date) -> String {
        DateFormatterFactory.formatter(with: "HH:mm").string(from: date)
    }
    
    private func updateNameLabelTopPadding(isFirst: Bool) {
        nameLabelTopAnchor.constant = isFirst ? 13 : 0
    }
    
    func configure(with model: ConversationMessageCellModel) {
        updateView(type: model.messageType)
        messageLabel.text = model.text
        timeLabel.text = get(date: model.date)
        
        if model.isFirstMessage && model.messageType == .incoming {
            nameLabel.text = model.userName
            updateNameLabelTopPadding(isFirst: model.isFirstMessage)
        }

        if model.isLastMessage && model.messageType == .incoming {
            leftTailImageView.isHidden = false
        } else if model.isLastMessage && model.messageType == .outcoming {
            rightTailImageView.isHidden = false
        }
    }
}

// MARK: - Constraints

private extension ConversationMessageCell {
    
    func setupViews() {
        backgroundColor = .systemBackground
        setupNameLabel()
        setupTails()
        setupTimeLabel()
        setupMessageLabel()
        setupContainerView()
    }
    
    func updateView(type: MessageType) {
        messageLabel.textColor = type == .incoming ? .black : .white
        timeLabel.textColor = type == .incoming ? .labelGray : .labelGrayInvert
        containerViewLeadingAnchor.isActive = type == .incoming ? true : false
        containerViewTrailingAnchor.isActive = type == .incoming ? false : true
        containerView.backgroundColor = type == .incoming ? .containerGray : .systemBlue
    }
    
    func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabelTopAnchor.isActive = true
        nameLabelTopAnchor.priority = .required - 1
        nameLabel.anchor(leading: contentView.leadingAnchor,
                         trailing: contentView.trailingAnchor,
                         padding: UIEdgeInsets(left: 32))
    }
    
    func setupTails() {
        containerView.addSubview(leftTailImageView)
        leftTailImageView.anchor(leading: containerView.leadingAnchor,
                                 bottom: containerView.bottomAnchor,
                                 padding: UIEdgeInsets(left: -5))
        
        containerView.addSubview(rightTailImageView)
        rightTailImageView.anchor(bottom: containerView.bottomAnchor,
                                  trailing: containerView.trailingAnchor,
                                  padding: UIEdgeInsets(right: -5))
    }
    
    func setupTimeLabel() {
        containerView.addSubview(timeLabel)
        timeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        timeLabel.anchor(bottom: containerView.bottomAnchor,
                         trailing: containerView.trailingAnchor,
                         padding: UIEdgeInsets(bottom: 6, right: 16))
    }
    
    func setupMessageLabel() {
        messageLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        messageLabel.numberOfLines = 0
        containerView.addSubview(messageLabel)
        messageLabel.anchor(top: containerView.topAnchor,
                            leading: containerView.leadingAnchor,
                            bottom: containerView.bottomAnchor,
                            trailing: timeLabel.leadingAnchor,
                            padding: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
    }
    
    func setupContainerView() {
        contentView.addSubview(containerView)
        containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 36).isActive = true
        containerView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.screenWidth - UIScreen.screenWidth / 4).isActive = true
        containerView.layer.cornerRadius = 18

        containerView.anchor(top: nameLabel.bottomAnchor,
                             bottom: contentView.bottomAnchor,
                             padding: UIEdgeInsets(top: 8))
    }
}
