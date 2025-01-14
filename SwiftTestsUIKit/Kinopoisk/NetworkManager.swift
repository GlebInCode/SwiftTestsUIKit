//
//  NetworkManager.swift
//  SwiftTestsUIKit
//
//  Created by Глеб Хамин on 13.01.2025.
//

import Foundation

enum Link {
    case top250

    var url: URL {
        switch self {
        case .top250:
            return URL(string: "https://api.kinopoisk.dev/v1.4/movie")!
        }
    }
}

enum NetworkError: Error {
    case noData
    case badRequest
    case decodingError
}

final class NetworkManager {
    init() {}

    static let shared = NetworkManager()

    func fetchMovies(completion: @escaping(Result<[Movie], NetworkError>) -> Void) {
        print("try to fech")

        let url = Link.top250.url
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "page", value: "1"),
          URLQueryItem(name: "limit", value: "250"),
          URLQueryItem(name: "selectFields", value: "id"),
          URLQueryItem(name: "selectFields", value: "name"),
          URLQueryItem(name: "selectFields", value: "poster"),
          URLQueryItem(name: "selectFields", value: "year"),
          URLQueryItem(name: "selectFields", value: "rating"),
          URLQueryItem(name: "lists", value: "top250"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "X-API-KEY": "KCTM2SY-JK04VQ9-GZT96ZJ-17JEX9Z"
        ]

        print(request)

        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if error != nil {
                print("Error in session is not nil")
                completion(.failure(.noData))
            } else {
                let httpResponse = response as? HTTPURLResponse
                print("Status code: \(String(describing: httpResponse?.statusCode))")

                if httpResponse?.statusCode != 200 {
                    completion(.failure(.badRequest))
                } else {
                    guard let safeData = data else {
                        print("Error safeData")
                        return
                    }

                    do {
                        let decodedQuery = try JSONDecoder().decode(MoviesList.self, from: safeData)
                        completion(.success(decodedQuery.docs))

                    } catch let decodeError {
                        print("Error decodedQuery \(decodeError)")
                        completion(.failure(.decodingError))
                    }
                }
            }
        }.resume()
    }
}
