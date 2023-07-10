//
//  CategoryCollectionViewCell.swift
//  NewYorkTimes
//
//  Created by MacBook on 06.07.2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: CategoryCollectionViewCell.self)

    let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = ""
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let publishedDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = ""
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let publishedTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = NSLocalizedString("PUBLISHED", comment: "")
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .mainCellBGColor
        layer.cornerRadius = 18
        
        addSubview(categoryNameLabel)
    
        let stackView = UIStackView(arrangedSubviews: [publishedTitleLabel, publishedDateLabel])
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            categoryNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            categoryNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            categoryNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
        ])
    }
    
    func configure(with viewModel: CategoriesViewModelCell) {
        categoryNameLabel.text = viewModel.title
        publishedDateLabel.text = viewModel.publishedDate
    }
}
