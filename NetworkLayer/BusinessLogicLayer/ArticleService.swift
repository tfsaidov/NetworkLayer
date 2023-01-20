//
//  MoviesService.swift
//  NetworkLayer
//
//  Created by Саидов Тимур on 18.01.2023.
//

import Foundation

protocol ArticleService: AnyObject {
    func newArticles(completion: @escaping (Result<[Article], NetworkRouterError>) -> Void)
}

final class ArticleServiceImp: ArticleService {
    
    private let router: NetworkRouter
    private let mapper: Mapper
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter
    }()
    
    init(router: NetworkRouter, mapper: Mapper) {
        self.router = router
        self.mapper = mapper
    }
    
    func newArticles(completion: @escaping (Result<[Article], NetworkRouterError>) -> Void) {
        self.router.request(ArticleApi.everything(query: "Tesla", from: self.dateFormatter.string(from: Date()))) { result in
            switch result {
            case .success(let data):
                self.mapper.parse(ArticleResponse.self, from: data) { result in
                    switch result {
                    case .success(let response):
                        completion(.success(response.articles))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
