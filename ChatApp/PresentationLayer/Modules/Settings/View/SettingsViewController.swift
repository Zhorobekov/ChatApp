//
//  ThemesViewController.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 12.03.2023.
//

import UIKit

final class SettingsViewController: BaseViewController {
    
    var presenter: SettingsPresenterProtocol?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemBackground
        return view
    }()
    private lazy var themeButtonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: themeButtonViews)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    private lazy var themeButtonViews = [ThemeButtonView(theme: .light), ThemeButtonView(theme: .dark)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupViews()
        setupThemeButtonViewCallback()
    }

    private func setupThemeButtonViewCallback() {
        for view in themeButtonViews {
            view.callback = { [weak self] theme in
                self?.themeButtonViewTapped(theme: theme)
                self?.presenter?.themeDidChange(theme: theme)
            }
        }
    }
    
    private func themeButtonViewTapped(theme: UIUserInterfaceStyle) {
        for view in themeButtonsStackView.arrangedSubviews {
            guard let view = view as? ThemeButtonView else { return }
            view.isSelected = view.theme == theme
        }
    }
}

extension SettingsViewController: SettingsViewProtocol {
    func setupThemeButtonsView(theme: UIUserInterfaceStyle) {
        for view in themeButtonViews {
            view.isSelected = view.theme == theme
        }
    }
}

// MARK: - Constraints

private extension SettingsViewController {

    func setupViews() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .secondarySystemBackground
        setupContainerView()
        setupThemeButtonsStackView()
    }
    
    func setupContainerView() {
        view.addSubview(containerView)
        let topInset = UIView.topSafeAreaInsets + (navigationController?.navigationBar.frame.height ?? 36) + 16
        containerView.anchor(top: view.topAnchor,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             padding: UIEdgeInsets(top: topInset, left: 16, right: 16))
    }
    
    func setupThemeButtonsStackView() {
        containerView.addSubview(themeButtonsStackView)
        themeButtonsStackView.fillSuperview(padding: UIEdgeInsets(top: 24, bottom: 24))
    }
}
