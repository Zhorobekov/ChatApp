//
//  ConversationMessageImageCell.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 28.04.2023.
//

import UIKit

final class ConversationMessageImageCell: UITableViewCell, ConfigurableViewProtocol {
  
    static var reuseId = String(describing: ConversationMessageImageCell.self)
    typealias ConfigurationModel = ConversationMessageCellModel
    
    private lazy var messageImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        imageView.image = placeholderImage
        imageView.tintColor = .separator
        return imageView
    }()
    private let placeholderImage = UIImage(named: "placeholder_image")?.withRenderingMode(.alwaysTemplate)
    private lazy var imageViewLeadingAnchor = messageImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
    private lazy var imageViewTrailingAnchor = messageImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageImageView.image = placeholderImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        contentView.addSubview(messageImageView)
        messageImageView.anchor(top: contentView.topAnchor,
                                bottom: contentView.bottomAnchor,
                                padding: UIEdgeInsets(top: 16),
                                size: CGSize(width: 130, height: 130))
    }
    
    func configure(with model: ConversationMessageCellModel) {
        imageViewLeadingAnchor.isActive = model.messageType == .incoming ? true : false
        imageViewTrailingAnchor.isActive = model.messageType == .incoming ? false : true
        messageImageView.set(imageUrl: model.text) { [weak self] in
            self?.messageImageView.image = self?.placeholderImage
        }
    }
    
}
