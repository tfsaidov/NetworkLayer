//
//  MovieEndPoint.swift
//  NetworkLayer
//
//  Created by Саидов Тимур on 18.01.2023.
//

import Foundation

enum ArticleApi {
    case everything(query: String, from: String)
}

extension ArticleApi: EndPointType {
    
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .prod:
            return "https://newsapi.org"
        case .test:
            return ""
        case .dev:
            return ""
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: self.environmentBaseURL) else {
            fatalError("baseURL could not be configured.")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .everything:
            return "/v2/everything"
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var task: HTTPTask {
        switch self {
        case let .everything(query, date):
            return .requestParameters(bodyParameters: nil,
                                      urlParameters: [
                                        "q": query,
                                        "from": date,
                                        "sortBy": "publishedAt",
                                        "apiKey": NetworkManager.articleAPIKey
                                      ])
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
}
