//
//  ArticleDetailViewController.swift
//  NYTTopStories
//
//  Created by Matthew Ramos on 2/7/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import ImageKit
import DataPersistence

class ArticleDetailViewController: UIViewController {
    
    private var article: Article
    
    private var dataPersitence: DataPersistence<Article>
    
    private let detailView = ArticleDetailView()
    
    init(_ dataPersistence: DataPersistence<Article>, article: Article) {
        self.dataPersitence = dataPersistence
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(saveArticleButtonPressed(_:)))
    }
    
    override func loadView() {
        view = detailView
    }
  

    func updateUI() {
        navigationItem.title = article.title
        detailView.abstractHeadline.text = article.abstract
        detailView.newImageView.getImage(with: article.getArticleImageURL(for: .superJumbo)){ [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.detailView.newImageView.image = UIImage(systemName: "gear")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.detailView.newImageView.image = image
                }
            }
        }
    }
    
    @objc
    func saveArticleButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try dataPersitence.createItem(article)
        } catch {
            print("Error saving article: \(error)")
        }
        
    }
}
