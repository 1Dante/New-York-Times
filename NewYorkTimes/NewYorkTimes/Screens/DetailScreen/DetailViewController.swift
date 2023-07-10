//
//  DetailViewController.swift
//  NewYorkTimes
//
//  Created by MacBook on 07.07.2023.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let detailView = DetailView()
    private var viewModel: DetailViewModel!
    private var coordinator: MainCoordinator?
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
        setUp()
        setUpActivityIndicator()
    }

    
    private func setUp() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let titleLabel = UILabel.title(with: viewModel.title)
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: detailView.safeAreaLayoutGuide.topAnchor, constant: -44).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 70).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -70).isActive = true

        detailView.collectionView.dataSource = self
        detailView.collectionView.delegate = self
        
        viewModel.reloadData = { isAvailable in
            if isAvailable {
                self.activityIndicator.stopAnimating()
                self.detailView.collectionView.reloadData()
            } else {
                self.addAlert()
            }
        }
        
        guard let navigationController = navigationController else { return }
        coordinator = MainCoordinator(navigationController: navigationController)
    }
    
    private func addAlert() {
        let title = NSLocalizedString("ALERT_ERROR", comment: "")
        let message = NSLocalizedString("ALERT_MESSAGE", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let actionTitle = NSLocalizedString("ACTION_TITLE", comment: "")
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel))
        self.present(alert, animated: true)
    }
    
    
    @objc func didTapAmazonButton(sender: UIButton) {
        guard let cell = sender.superview?.superview as? BookCollectionViewCell else { return }
        guard let indexPath = detailView.collectionView.indexPath(for: cell) else { return }
        
        let url = viewModel.books[indexPath.row].amazonBuyLink
        coordinator?.openWebView(url: url)
    }

    @objc func didTapAppleButton(sender: UIButton) {
        guard let cell = sender.superview?.superview as? BookCollectionViewCell else { return }
        guard let indexPath = detailView.collectionView.indexPath(for: cell) else { return }
        
        let url = viewModel.books[indexPath.row].appleBuyLink
        coordinator?.openWebView(url: url)
    }
    
    private func setUpActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.reuseIdentifier, for: indexPath) as! BookCollectionViewCell
        cell.configure(with: viewModel.books[indexPath.row])
        cell.amazonLinkButton.addTarget(self, action: #selector(didTapAmazonButton), for: .touchUpInside)
        cell.appleLinkButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        return cell
    }
}
