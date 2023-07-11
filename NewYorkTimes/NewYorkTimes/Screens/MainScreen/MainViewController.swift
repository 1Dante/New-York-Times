//
//  MainViewController.swift
//  NewYorkTimes
//
//  Created by MacBook on 06.07.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let mainView = MainView()
    private var coordinator: MainCoordinator?
    private let viewModel = MainViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        setUp()
        setUpActivityIndicator()
    }
    
    private func setUp() {
        let title = NSLocalizedString("MAIN_TITLE_NAV_BAR", comment: "")
        navigationItem.titleView = UILabel.title(with: title)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        
        viewModel.reloadData = { isAvailable in
            if isAvailable {
                self.activityIndicator.stopAnimating()
                self.mainView.collectionView.reloadData()
            } else {
                self.addAlert()
            }
        }
        
        guard let navigationController = navigationController else { return }
        coordinator = MainCoordinator(navigationController: navigationController)
    }
    
    private func setUpActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    private func addAlert() {
        let title = NSLocalizedString("ALERT_ERROR", comment: "")
        let message = NSLocalizedString("ALERT_MESSAGE", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let actionTitle = NSLocalizedString("ACTION_TITLE", comment: "")
        let action = UIAlertAction(title: actionTitle, style: .cancel) {_ in
            self.activityIndicator.stopAnimating()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        cell.configure(with: viewModel.categories[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewModel = DetailViewModel(category: viewModel.categories[indexPath.row])
        coordinator?.openDetailVC(viewModel: detailViewModel)
    }
}
