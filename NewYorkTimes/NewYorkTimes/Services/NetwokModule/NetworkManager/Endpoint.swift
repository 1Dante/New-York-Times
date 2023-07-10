//
//  Endpoint.swift
//  NewYorkTimes
//
//  Created by MacBook on 06.07.2023.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var query: [URLQueryItem] { get }
}
