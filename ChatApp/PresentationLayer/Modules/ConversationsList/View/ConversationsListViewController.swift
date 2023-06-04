//
//  MainViewController.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 19.02.2023.
//

import UIKit

enum ConversationsListSection: Int, Hashable, CaseIterable {
    case channels
}

final class ConversationsListViewController: BaseViewController {
    
    var presenter: ConversationsListPresenterProtocol?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(ConversationCell.self, forCellReuseIdentifier: ConversationCell.reuseId)
        tableView.addSubview(refreshControl)
        tableView.estimatedRowHeight = 100
        tableView.clipsToBounds = true
        return tableView
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = .systemGray
        return refreshControl
    }()
    private lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .systemGray
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var blurEffectView: UIVisualEffectView = {
        let style: UIBlurEffect.Style = presenter?.currentTheme == .light ? .light : .dark
        let blurEffect = UIBlurEffect(style: style)
        let visualEffect = UIVisualEffectView(effect: blurEffect)
        visualEffect.alpha = 0
        return visualEffect
    }()
    private var createAction: UIAlertAction?
    private lazy var dataSource = DataSource(tableView)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getChannels()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupViews()
        setupDataSource()
    }

    private func setupViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupTableView()
        setupBlurEffect()
        setupIndicatorView()
    }

    private func setupNavigation() {
        let addChannelButton = UIBarButtonItem(title: "Add channel", style: .plain, target: self, action: #selector(addChannelTapped))

        navigationItem.rightBarButtonItem = addChannelButton
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.fillSuperview(padding: UIEdgeInsets(top: navigationController?.navigationBar.frame.height ?? 0 + UIView.topSafeAreaInsets))
    }
    
    private func setupIndicatorView() {
        view.addSubview(indicatorView)
        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupBlurEffect() {
        view.addSubview(blurEffectView)
        blurEffectView.fillSuperview()
    }
    
    private func showAlertWithTextField() {
        let alert = UIAlertController(title: "New Channel", message: nil, preferredStyle: .alert)
        
        createAction = UIAlertAction(title: "Create", style: .default) { [weak self] _ in
            self?.presenter?.createChannel(name: alert.textFields?.first?.text)
        }
        guard let createAction else { return }
        createAction.isEnabled = false
        
        alert.addTextField { [weak self] textField in
            textField.placeholder = "Channel Name"
            textField.addTarget(self, action: #selector(self?.textFieldDidChange), for: .allEvents)
        }
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)

        alert.addAction(cancelAction)
        alert.addAction(createAction)
        
        present(alert, animated: true, completion: nil)
    }

    private func setupDataSource() {
        guard let presenter else { return }
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(ConversationsListSection.allCases)
        snapshot.appendItems(presenter.channels, toSection: .channels)
        dataSource.apply(snapshot)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let createAction, let text = textField.text else { return }
        createAction.isEnabled = !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    @objc private func addChannelTapped() {
       showAlertWithTextField()
    }
    
    @objc private func refresh() {
        presenter?.getChannels()
    }
}

// MARK: - data source

private final class DataSource: UITableViewDiffableDataSource<ConversationsListSection, ChannelModel> {

    init(_ tableView: UITableView) {
    
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.reuseId, for: indexPath) as? ConversationCell
            else {
                return UITableViewCell()
            }
            cell.configure(with: itemIdentifier)
            return cell
        }
    }
}

extension ConversationsListViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter else { return }
        Vibration.vibrate()
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectRowAt(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { (_, _, _) in
            self.presenter?.deleteChannel(at: indexPath.row)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
}

extension ConversationsListViewController: ConversationsListViewProtocol {

    func showLoading() {
        view.isUserInteractionEnabled = false
        indicatorView.startAnimating()
    }
    
    func hideLoading() {
        indicatorView.stopAnimating()
        refreshControl.endRefreshing()
        view.isUserInteractionEnabled = true
    }
    
    func showErrorAlert(message: String) {
        let message = message.isEmpty ? "Something went wrong" : message
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }

    func reloadData() {
        guard let presenter else { return }
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(ConversationsListSection.allCases)
        snapshot.appendItems(presenter.channels, toSection: .channels)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func reload(channel: ChannelModel) {
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([channel])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
