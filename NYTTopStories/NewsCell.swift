//
//  NewsCell.swift
//  NYTTopStories
//
//  Created by Matthew Ramos on 2/7/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import ImageKit

class NewsCell: UICollectionViewCell {
    
    //image view of the article
    //title of article
    //abstract of article
    public lazy var newImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "photo")
        iv.backgroundColor = .systemYellow
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    public lazy var articleTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "Article Title"
        label.textAlignment = .center
        return label
    }()
    
    public lazy var abstractHeadline: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.text = "Abstract Title"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupImageViewConstraints()
        setupArticleTitleConstraints()
        setupAbstractHeadlineConstraints()
    }
    
    private func setupImageViewConstraints() {
        addSubview(newImageView)
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            newImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            newImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.30),
            newImageView.widthAnchor.constraint(equalTo: newImageView.heightAnchor)
        
        
        ])
    }
    
    private func setupArticleTitleConstraints() {
        addSubview(articleTitle)
        articleTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            articleTitle.topAnchor.constraint(equalTo: newImageView.topAnchor),
            articleTitle.leadingAnchor.constraint(equalTo: newImageView.trailingAnchor, constant: 8),
            articleTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    private func setupAbstractHeadlineConstraints() {
        addSubview(abstractHeadline)
        abstractHeadline.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            abstractHeadline.leadingAnchor.constraint(equalTo: articleTitle.leadingAnchor),
            abstractHeadline.trailingAnchor.constraint(equalTo: articleTitle.trailingAnchor),
            abstractHeadline.topAnchor.constraint(equalTo: articleTitle.bottomAnchor, constant: 8)
        
        ])
    }
    
    public func configureCell(with article: Article) {
        articleTitle.text = article.title
        abstractHeadline.text = article.abstract
        
        newImageView.getImage(with: article.getArticleImageURL(for: .thumbLarge)) { [weak self ](result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.newImageView.image = UIImage(systemName: "exclamationmark-octagon")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.newImageView.image = image
                }
            }
        }
    }

}
