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
    
    var article: Article?
    
    public var dataPersitence: DataPersistence<Article>!
    
    private let detailView = ArticleDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(saveArticleButtonPressed(_:)))
    }
    
    override func loadView() {
        view = detailView
    }
  

    func updateUI() {
        guard let article = article else {
            fatalError("Did not load an article")
        }
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
        guard let article = article else { return }
        do {
            try dataPersitence.createItem(article)
        } catch {
            print("Error saving article: \(error)")
        }
        
    }
}
