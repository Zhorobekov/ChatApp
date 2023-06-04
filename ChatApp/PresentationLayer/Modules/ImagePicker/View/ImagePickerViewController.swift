//
//  ImagePickerViewController.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 23.04.2023.
//

import UIKit

enum Section {
    case main
}

final class ImagePickerViewController: BaseViewController {

    var presenter: ImagePickerPresenterProtocol?
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .systemGray
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.delegate = self
        return collectionView
    }()
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupCollectionView()
        configureDataSource()
        setupIndicatorView()
        presenter?.viewDidLoad()
    }
    
    private func setupNavigation() {
        title = "Select photo"
        let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButtonItem
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.fillSuperview(padding: UIEdgeInsets(left: 2, right: 2))
    }
    
    private func setupIndicatorView() {
        view.addSubview(indicatorView)
        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 3),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(1.0 / 3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(2)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<ImagePickerCell, String> { [weak self] (cell, indexPath, _) in
            cell.setup(imageUrl: self?.presenter?.imageUrls[indexPath.row])
        }
        
        // swiftlint: disable line_length
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        // swiftlint: enable line_length

        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        guard let presenter else { return }
        snapshot.appendSections([.main])
        snapshot.appendItems(presenter.imageUrls)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension ImagePickerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       guard let cell = collectionView.cellForItem(at: indexPath) as? ImagePickerCell else { return }
        let selectedImageData = cell.imageView.image?.jpegData(compressionQuality: 1)
        presenter?.localImageDidChange(imageData: selectedImageData) {
            dismiss(animated: true)
        }
    }
}

extension ImagePickerViewController: ImagePickerViewProtocol {
    func reloadData() {
        var snapshot = dataSource.snapshot()
        guard let presenter else { return }
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(presenter.imageUrls)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func showLoading() {
        indicatorView.startAnimating()
    }
    
    func hideLoading() {
        indicatorView.stopAnimating()
    }
    
    func showErrorAlert(message: String) {
        let message = message.isEmpty ? "Something went wrong" : message
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
