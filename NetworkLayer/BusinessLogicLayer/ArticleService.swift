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
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter
    }()
    
    init(router: NetworkRouter) {
        self.router = router
    }
    
    func newArticles(completion: @escaping (Result<[Article], NetworkRouterError>) -> Void) {
        self.router.request(ArticleApi.everything(query: "Tesla", from: self.dateFormatter.string(from: Date()))) { result in
            switch result {
            case .success(let data):
                do {
                    let responce = try JSONDecoder().decode(ArticleResponse.self, from: data)
                    completion(.success(responce.articles))
                } catch {
                    completion(.failure(.serverError(.decodingError)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
