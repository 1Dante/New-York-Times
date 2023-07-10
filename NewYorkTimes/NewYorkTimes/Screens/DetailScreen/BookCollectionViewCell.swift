//
//  BookCollectionViewCell.swift
//  NewYorkTimes
//
//  Created by MacBook on 07.07.2023.
//

import UIKit
import Kingfisher

class BookCollectionViewCell: UICollectionViewCell {
   
    static let reuseIdentifier = String(describing: BookCollectionViewCell.self)
    
    let rankLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.text = "#1"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = ""
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = ""
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let publisherLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = ""
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = ""
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let bookImageView = UIImageView()
    
    let amazonLinkButton = UIButton()
    let appleLinkButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func setUp() {
        addSubview(rankLabel)
        addSubview(bookImageView)
        addSubview(descriptionLabel)
        let myAttributes: [NSAttributedString.Key : Any] = [ NSAttributedString.Key.foregroundColor: UIColor.blue,
                                                             NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedAmazonString = NSAttributedString(string: "Amazon", attributes: myAttributes)
        amazonLinkButton.setAttributedTitle(attributedAmazonString, for: .normal)
        let attributedAppleString = NSAttributedString(string: "Apple", attributes: myAttributes)
        appleLinkButton.setAttributedTitle(attributedAppleString, for: .normal)
        backgroundColor = .mainCellBGColor
        layer.cornerRadius = 18
        bookImageView.layer.cornerRadius = 8
        bookImageView.clipsToBounds = true
    }
    
    private func setUpConstraints() {
        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let topLabelStack = UIStackView(arrangedSubviews: [bookTitleLabel, authorLabel, publisherLabel])
        topLabelStack.axis = .vertical
        topLabelStack.spacing = 5
        topLabelStack.translatesAutoresizingMaskIntoConstraints = false
        topLabelStack.alignment = .leading
        addSubview(topLabelStack)
        
        
        let buttonStack = UIStackView(arrangedSubviews: [appleLinkButton, amazonLinkButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            bookImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            bookImageView.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            bookImageView.heightAnchor.constraint(equalToConstant: 100),
            bookImageView.widthAnchor.constraint(equalToConstant: 80),
            
            rankLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            rankLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            
            topLabelStack.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            topLabelStack.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 5),
            topLabelStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            buttonStack.topAnchor.constraint(equalTo: topLabelStack.bottomAnchor, constant: 5),
            buttonStack.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 0),
            buttonStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            buttonStack.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 4),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
    }
    
    func configure(with viewModel: BookCellViewModel) {
        rankLabel.text = "#" + viewModel.rank
        bookTitleLabel.text = viewModel.title
        authorLabel.text = viewModel.author
        publisherLabel.text = NSLocalizedString("PUBLISHER", comment: "") + " " + viewModel.publisher
        if let url = URL(string: viewModel.imageURL) {
            bookImageView.kf.setImage(with: url)
        }
        descriptionLabel.text = viewModel.description
    }
}
