//
//  Extentions+Foundation.swift
//  NewYorkTimes
//
//  Created by MacBook on 10.07.2023.
//

import Foundation

extension Date {
    static func getDate(str: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.date(from: str) ?? Date()
    }
}
