//
//  ViewController.swift
//  NetworkLayer
//
//  Created by Саидов Тимур on 18.01.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    private let articleService: ArticleService
    
    init(articleService: ArticleService) {
        self.articleService = articleService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.fetchArticles()
    }
    
    private func setupView() {
        self.view.backgroundColor = .systemGreen
    }
    
    private func fetchArticles() {
        self.articleService.newArticles { result in
            switch result {
            case .success(let articles):
                print("✅", articles)
            case .failure(let error):
                print("❌", error.localizedDescription)
            }
        }
    }
}
