//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 08.03.2023.
//

import UIKit

final class ConversationViewController: BaseViewController {
    
    var presenter: ConversationsPresenterProtocol?
    
    private lazy var topNavigationBar = TopNavigationBar { [weak self] in
        self?.navigationController?.popToRootViewController(animated: true)
    }
    private lazy var sendField: SendField = {
        let textField = SendField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.layer.cornerRadius = 18
        textField.backgroundColor = .systemBackground
        textField.attributedPlaceholder = Constants.Conversation.sendFieldPlaceholder
        textField.clipsToBounds = true
        textField.addTarget(self, action: #selector(sendFieldDidChange), for: .allEvents)
        return textField
    }()
    private lazy var sendButton: PaddingButton = {
        let button = PaddingButton(inset: 15)
        button.backgroundColor = .systemGray4
        button.setImage(Constants.Conversation.arrowUpImage, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.register(ConversationMessageCell.self, forCellReuseIdentifier: ConversationMessageCell.reuseId)
        tableView.register(ConversationMessageImageCell.self, forCellReuseIdentifier: ConversationMessageImageCell.reuseId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.estimatedRowHeight = 100
        return tableView
    }()
    private lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = UITraitCollection.current.userInterfaceStyle == .light ? .black : .white
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var dataSource = DataSource(tableView)
    private lazy var sendFieldBottomInset: CGFloat = -(UIView.bottomSafeAreaInsets + 8)
    private lazy var sendFieldBottomConstraint = sendField.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                                   constant: sendFieldBottomInset)
    private lazy var sendFieldBottomWithKeyboardConstraint = sendField.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                                   constant: sendFieldBottomInset)
    private var isKeyboardShow = false {
        didSet {
            sendFieldBottomConstraint.isActive = !isKeyboardShow
            sendFieldBottomWithKeyboardConstraint.isActive = isKeyboardShow
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.viewDidDissapear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset.bottom = topNavigationBar.frame.height
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupKeyboardObserver()
        setupViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        sendField.resignFirstResponder()
    }
    
    private func showNoUserAlert() {
        let message = "Для отправки сообщения необходимо создать профиль"
        let alert = UIAlertController(title: "У вас нет профиля(", message: message, preferredStyle: .alert)
        let showProfileViewAction = UIAlertAction(title: "Создать профиль", style: .default) { [weak self] _ in
            if let tabBarController = self?.tabBarController {
                tabBarController.selectedIndex = 2
                let transition = CATransition()
                transition.duration = 0.2
                transition.type = CATransitionType.fade
                tabBarController.view.layer.add(transition, forKey: kCATransition)
            }
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .default))
        alert.addAction(showProfileViewAction)

        self.present(alert, animated: true, completion: nil)
    }

    @objc private func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func sendButtonTapped() {
        guard let text = sendField.text else { return }
        do {
            try presenter?.sendMessage(text: text)
            sendField.text = nil
            sendButton.isEnabled = false
        } catch {
            showNoUserAlert()
            sendField.text = nil
        }
    }
    
    @objc private func sendFieldDidChange() {
        sendButton.isEnabled = !sendField.text.isNilOrEmpty
        sendButton.backgroundColor = sendField.text.isNilOrEmpty ? .systemGray4 : .systemBlue
    }
}

// MARK: - Constraints

private extension ConversationViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupSendField()
        setupIndicatorView()
        setupTableView()
        view.bringSubviewToFront(topNavigationBar)
        view.bringSubviewToFront(sendButton)
    }
    
    func setupNavigationBar() {
        view.addSubview(topNavigationBar)
        topNavigationBar.anchor(top: view.topAnchor,
                                leading: view.leadingAnchor,
                                trailing: view.trailingAnchor)
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor,
                         leading: view.leadingAnchor,
                         bottom: sendField.topAnchor,
                         trailing: view.trailingAnchor,
                         padding: UIEdgeInsets(top: UIView.topSafeAreaInsets))
    }
    
    func setupSendField() {
        view.addSubview(sendField)
        sendField.anchor(leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         padding: UIEdgeInsets(left: 8, right: 8),
                         size: CGSize(width: 0, height: 36))
        sendFieldBottomConstraint.isActive = true

        view.addSubview(sendButton)
        sendButton.centerYAnchor.constraint(equalTo: sendField.centerYAnchor).isActive = true
        sendButton.anchor(trailing: sendField.trailingAnchor,
                          padding: UIEdgeInsets(right: 8),
                          size: CGSize(width: 28, height: 28))
    }

    func setupIndicatorView() {
        view.addSubview(indicatorView)
        indicatorView.anchor(size: CGSize(width: 45, height: 45))
        indicatorView.centerXAnchor.constraint(equalTo: sendButton.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
    }
}

// MARK: - data source

private final class DataSource: UITableViewDiffableDataSource<ConversationMessageSection, ConversationMessageCellModel> {
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            switch itemIdentifier.contentType {
            case .text:
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: ConversationMessageCell.reuseId,
                                                             for: indexPath) as? ConversationMessageCell
                else {
                    return UITableViewCell()
                }
                cell.transform = CGAffineTransform(scaleX: 1, y: -1)
                cell.configure(with: itemIdentifier)
                return cell
            case .image:
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: ConversationMessageImageCell.reuseId,
                                                             for: indexPath) as? ConversationMessageImageCell
                else {
                    return UITableViewCell()
                }
                cell.transform = CGAffineTransform(scaleX: 1, y: -1)
                cell.configure(with: itemIdentifier)
                return cell
            }
        }
    }
}

extension ConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let presenter, !presenter.sections.isEmpty else { return nil }
        let label = UILabel()
        label.transform = CGAffineTransform(scaleX: 1, y: -1)
        label.textAlignment = .center
        label.text = presenter.getTitleFor(section: section)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        36
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendField.resignFirstResponder()
    }
}

// MARK: - Keyboard Notification

private extension ConversationViewController {
    func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        sendFieldBottomInset = -(keyboardHeight - UIView.bottomSafeAreaInsets + 36)
        isKeyboardShow = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        sendFieldBottomInset = -36
        isKeyboardShow = false
    }
}

extension ConversationViewController: ConversationViewProtocol {

    func setupChannel(name: String, image: String?) {
        topNavigationBar.configureView(name: name, image: image)
    }

    func setupDataSource() {
        guard let presenter else { return }
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(presenter.sections)
        
        for seciton in presenter.sections {
            snapshot.appendItems(seciton.messages, toSection: seciton)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func showErrorAlert(message: String) {
        let message = message.isEmpty ? "Something went wrong" : message
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }

    func showLoading() {
        sendButton.isEnabled = false
        sendButton.backgroundColor = .systemGray4
        sendButton.alpha = 0.4
        indicatorView.startAnimating()
    }
    
    func hideLoading() {
        sendButton.alpha = 1
        indicatorView.stopAnimating()
    }
}
