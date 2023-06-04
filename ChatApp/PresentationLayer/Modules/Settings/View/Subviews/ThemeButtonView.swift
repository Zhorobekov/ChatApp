//
//  ThemeButtonView.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 12.03.2023.
//

import UIKit

final class ThemeButtonView: UIView {

    private lazy var themeImageView: UIImageView = {
        let imageView = UIImageView()
        let imageName = theme == .light ? Constants.ThemeButton.lightImageName : Constants.ThemeButton.darkImageName
        imageView.image = UIImage(named: imageName)
        return imageView
    }()
    private lazy var themeLabel: UILabel = {
        let label = UILabel()
        let labelText = theme == .light ? Constants.ThemeButton.dayString : Constants.ThemeButton.darkString
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = labelText
        label.textAlignment = .center
        return label
    }()
    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.ThemeButton.chekmarkImageSize.height / 2
        imageView.contentMode = .center
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        return imageView
    }()
    
    let theme: UIUserInterfaceStyle
    var isSelected = false {
        didSet {
            checkmarkImageView.image = isSelected ? Constants.ThemeButton.chekmarkImage : nil
            checkmarkImageView.layer.borderWidth = isSelected ? 0 : 2
        }
    }
    
    var callback: ((UIUserInterfaceStyle) -> Void)?
    
    init(theme: UIUserInterfaceStyle) {
        self.theme = theme
        super.init(frame: .zero)
        setupViews()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    @objc private func viewTapped() {
        Vibration.vibrate()
        callback?(theme)
    }
}

// MARK: - Constraints

private extension ThemeButtonView {

    func setupViews() {
        setupThemeImageView()
        setupThemeLabel()
        setupCheckmarkImageView()
    }
    
    func setupThemeImageView() {
        addSubview(themeImageView)

        NSLayoutConstraint.activate([
            themeImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            themeImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            themeImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35)
        ])
    
        themeImageView.anchor(top: topAnchor)
    }
    
    func setupThemeLabel() {
        addSubview(themeLabel)
        themeLabel.anchor(top: themeImageView.bottomAnchor,
                          leading: leadingAnchor,
                          trailing: trailingAnchor,
                          padding: UIEdgeInsets(top: 10))
    }
    
    func setupCheckmarkImageView() {
        addSubview(checkmarkImageView)
        checkmarkImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        checkmarkImageView.anchor(top: themeLabel.bottomAnchor,
                                  bottom: bottomAnchor,
                                  padding: UIEdgeInsets(top: 10),
                                  size: Constants.ThemeButton.chekmarkImageSize)
    }
}
