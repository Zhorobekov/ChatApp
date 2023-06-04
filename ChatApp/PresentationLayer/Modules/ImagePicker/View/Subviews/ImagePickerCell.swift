//
//  ImagePickerCell.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 24.04.2023.
//

import UIKit

final class ImagePickerCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: ImagePickerCell.self)
    private let placeholderImage = UIImage(named: "placeholder_image")?.withRenderingMode(.alwaysTemplate)

    lazy var imageView: WebImageView = {
        let imageView = WebImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = placeholderImage
        imageView.tintColor = .separator
        imageView.clipsToBounds = true
        return imageView
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = placeholderImage
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    func setup(imageUrl: String?) {
        imageView.set(imageUrl: imageUrl) { [weak self] in
            self?.imageView.image = self?.placeholderImage
        }
    }

}

extension ImagePickerCell {
    
    private func setupViews() {
        contentView.addSubview(imageView)
        imageView.fillSuperview()
    }
}
