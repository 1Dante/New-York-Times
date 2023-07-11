//
//  LiveData.swift
//  NewYorkTimes
//
//  Created by MacBook on 06.07.2023.
//

import Foundation


struct LiveData<Type:Codable>: Codable {
    var results: Type
    var count: Int?
    
    enum CodingKeys: String, CodingKey {
            case results
            case count = "num_results"
    }
}

struct ResultNetwork: Codable {
    let listName: String
    let displayName: String
    let encodedName: String
    let newestPublishedDate: String?
    let books: [Book]?
    
    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case displayName = "display_name"
        case encodedName = "list_name_encoded"
        case newestPublishedDate = "newest_published_date"
        case books
    }   
}

struct Book: Codable {
    let rank: Int
    let title: String
    let description: String
    let publisher: String
    let author: String
    let imageURL: String
    let buyLinks: [BuyLinks]
    
    enum CodingKeys: String, CodingKey {
        case rank, title, description, publisher, author
        case imageURL = "book_image"
        case buyLinks = "buy_links"
    }
}

struct BuyLinks: Codable {
    let name: String
    let url: String
}
              



