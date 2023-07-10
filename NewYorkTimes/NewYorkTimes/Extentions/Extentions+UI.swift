//
//  Extentions+UI.swift
//  NewYorkTimes
//
//  Created by MacBook on 06.07.2023.
//

import UIKit

extension UIColor {
    static let bgColor = UIColor(red: 0.9725, green: 0.9882, blue: 0.851, alpha: 1.0)
    static let mainCellBGColor = UIColor(red: 0.9216, green: 0.9373, blue: 0.8078, alpha: 1.0)
}

extension UILabel {
    static func title(with text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 350, height: 150))
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.font = UIFont(name: "Chomsky", size: 28)
        label.text = text
        label.textAlignment = .center
       // label.sizeToFit()
        label.numberOfLines = 2
        return label
    }
}
