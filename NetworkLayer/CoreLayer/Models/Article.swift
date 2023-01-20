//
//  Movie.swift
//  NetworkLayer
//
//  Created by Саидов Тимур on 18.01.2023.
//

import Foundation

struct Article: Codable {
    let source: Source
    let author: String?
    let imageURL: String?
    let content: String?
    let title: String
    let description: String?
    let url: String
    let publishedAt: String

    struct Source: Codable {
        let id: String?
        let name: String
    }

    enum CodingKeys: String, CodingKey {
        case source, author, title, description, url, publishedAt, content
        case imageURL = "urlToImage"
    }
}
