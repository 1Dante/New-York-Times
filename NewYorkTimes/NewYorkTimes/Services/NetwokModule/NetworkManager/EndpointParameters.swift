//
//  EndpointParameters.swift
//  NewYorkTimes
//
//  Created by MacBook on 06.07.2023.
//

import Foundation

enum EndpointParameters: Endpoint {
    
    case lists
    case bookLists(encodedName: String)
    
    var path: String {
        switch self {
        case .lists:
            return "/svc/books/v3/lists/names.json"
        case .bookLists(let encodedList):
            return "/svc/books/v3/lists/current/" + encodedList + ".json"
            
        }
    }
    
    var query: [URLQueryItem] {
        var queryItem: [URLQueryItem] = []
        switch self {
        case .lists:
            queryItem.append(URLQueryItem(name: "api-key", value: NetworkManager.shared.keySDK))
            return queryItem
        case .bookLists(encodedName: let encodedName):
            queryItem.append(URLQueryItem(name: "api-key", value: NetworkManager.shared.keySDK))
            return queryItem
        }
    }
    
    
}
