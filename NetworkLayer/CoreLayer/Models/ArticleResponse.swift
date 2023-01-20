//
//  Moview.swift
//  NetworkLayer
//
//  Created by Саидов Тимур on 18.01.2023.
//

import Foundation

struct ArticleResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
