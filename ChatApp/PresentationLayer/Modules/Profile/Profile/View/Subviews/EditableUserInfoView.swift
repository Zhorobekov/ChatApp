//
//  EditUserTextfield.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 19.03.2023.
//

import UIKit

final class EditableUserInfoView: UIView {
    
    private let title: String
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = title
        label.numberOfLines = 0
        label.font = Constants.Font.systemFont17
        return label
    }()
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = Constants.Font.systemFont17
        textView.textContainer.maximumNumberOfLines = 1
        return textView
    }()
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = Constants.Font.systemFont17
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .allEvents)
        return textField
    }()

    var callback: (() -> Void)?
    
    init(title: String, placeholder: String?) {
        self.title = title
        super.init(frame: .zero)
        setupViews()
        self.textField.placeholder = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldBecomeFirstResponder() {
        textField.becomeFirstResponder()
    }
    
    func textFieldResignFirstResponder() {
        textField.resignFirstResponder()
    }
    
    @objc private func textFieldDidChange() {
        callback?()
    }
}

// MARK: - Constraints

private extension EditableUserInfoView {
    func setupViews() {
        backgroundColor = .systemBackground
        setupTitleLabel()
        setupTextField()
        setupSeparator()
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor,
                          leading: leadingAnchor,
                          bottom: bottomAnchor,
                          padding: UIEdgeInsets(top: 11, left: 16, bottom: 11),
                          size: CGSize(width: 98, height: 0))
    }
    
    func setupTextField() {
        addSubview(textField)
        textField.anchor(top: topAnchor,
                        leading: titleLabel.trailingAnchor,
                        bottom: bottomAnchor,
                        trailing: trailingAnchor,
                        padding: UIEdgeInsets(top: 11, left: 8, bottom: 11, right: 36),
                         size: CGSize(width: 0, height: textField.font?.lineHeight ?? 0))
    }
    
    func setupSeparator() {
        addSubview(separatorView)
        separatorView.anchor(leading: titleLabel.leadingAnchor,
                             bottom: bottomAnchor,
                             trailing: trailingAnchor,
                             size: CGSize(width: 0, height: 1))
    }
}
