//
//  ModelAPIMovies.swift
//  SwiftTestsUIKit
//
//  Created by Глеб Хамин on 13.01.2025.
//

import Foundation

struct MoviesList: Codable {
    let docs: [Movie]
    let total: Int
    let limit: Int
    let page: Int
    let pages: Int
}

struct Movie: Codable {
    let id: Int
    let name: String
    let year: Int
    let rating: Rating
    let poster: Poster
}

struct Rating: Codable {
    let kp: Double
}

struct Poster: Codable {
    let url: String
}
