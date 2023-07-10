//
//  NetworkManager.swift
//  NewYorkTimes
//
//  Created by MacBook on 06.07.2023.
//

import Foundation
import Alamofire

class NetworkManager {
    let keySDK = "tIWIpksvpPddoUujQH0lm3Uv0b3NpZ6g"
    private let url = "https://api.nytimes.com"
    static let shared = NetworkManager()
    
    private func createURL(endpoint: Endpoint) -> URL {
        let url = URL(string: url)
        var urlComponents = URLComponents(url: url!, resolvingAgainstBaseURL: true)
        
        urlComponents?.path = endpoint.path
        urlComponents?.queryItems = endpoint.query
        return urlComponents!.url!
    }
    
    func fetchData<Type: Codable>(type: Type.Type, endpoint: EndpointParameters) async throws -> Type {
        let url = createURL(endpoint: endpoint)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        print(url)
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<Type, Error>) in
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: Type.self, decoder: decoder) { (response) in
                if response.error != nil {
                    continuation.resume(throwing: response.error!)
                    return
                } else {
                    guard let live = response.value else { return }
                    continuation.resume(returning: live)
                    return
                }
            }
        })
    }
}

