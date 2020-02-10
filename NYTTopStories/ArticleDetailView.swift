//
//  ArticleDetailView.swift
//  NYTTopStories
//
//  Created by Matthew Ramos on 2/7/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class ArticleDetailView: UIView {
    
    
    public lazy var newImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "photo")
        iv.backgroundColor = .systemYellow
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    public lazy var abstractHeadline: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.text = "Abstract Headline"
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
        setupNewsImageViewConstaints()
        setupAbstractHeadlineConstraints()
    }

    private func setupNewsImageViewConstaints() {
        addSubview(newImageView)
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            newImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            newImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.40)
        
        ])
    }
    
    private func setupAbstractHeadlineConstraints() {
        addSubview(abstractHeadline)
        abstractHeadline.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            abstractHeadline.topAnchor.constraint(equalTo: newImageView.bottomAnchor, constant: 8),
            abstractHeadline.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            abstractHeadline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
        
        ])
    }
}
