//
//  SavedArticleCell.swift
//  NYTTopStories
//
//  Created by Matthew Ramos on 2/10/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

protocol SavedArticleCellDelegate: AnyObject {
    func didSelectMoreButton(_ savedArticleCell: SavedArticleCell, article: Article)
}

class SavedArticleCell: UICollectionViewCell {
    
    weak var delegate: SavedArticleCellDelegate?
    
    private var currentArticle: Article!
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(didLongPress(_:)))
        return gesture
    }()
    
    public lazy var moreButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(moreButtonWasPressed(_:)), for: .touchUpInside)
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        return button
    }()
    
    public lazy var articleTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = "Article Title"
        return label
    }()
    
    public lazy var newImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "photo")
        iv.alpha = 0
        iv.clipsToBounds = true
        return iv
    }()
    
    private var isShowingImage = false
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupMoreButtonConstraints()
        setupArticleTitleConstraints()
        setupImageViewConstraints()
        addGestureRecognizer(longPressGesture)
    }
    
    @objc
    private func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard let currentArticle = currentArticle else { return }
        if gesture.state == .began || gesture.state == .changed {
            print("long pressed")
            return
        }
        
        isShowingImage.toggle()
        
        newImageView.getImage(with: currentArticle.getArticleImageURL(for: .normal)) { [weak self] (result) in
            switch result {
            case .failure:
                break
            case .success(let image):
                DispatchQueue.main.async {
                    self?.newImageView.image = image
                    self?.animate()
                }
            }
        }
        }
    
    private func animate() {
        let duration: Double = 1.0
        if isShowingImage {
            
        
        UIView.transition(with: self, duration: duration, options: [], animations: {
            self.newImageView.alpha = 1.0
            self.articleTitle.alpha = 0.0
        }, completion: nil)
        } else {
            self.newImageView.alpha = 0.0
            self.articleTitle.alpha = 1.0
        }
    }
    
    @objc
    private func moreButtonWasPressed(_ sender: UIButton) {
        delegate?.didSelectMoreButton(self, article: currentArticle)
    }
    
    private func setupMoreButtonConstraints() {
       addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moreButton.topAnchor.constraint(equalTo: topAnchor),
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            moreButton.heightAnchor.constraint(equalToConstant: 44),
            moreButton.widthAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    private func setupArticleTitleConstraints() {
        addSubview(articleTitle)
        articleTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            articleTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            articleTitle.trailingAnchor.constraint(equalTo: trailingAnchor),
            articleTitle.topAnchor.constraint(equalTo: moreButton.bottomAnchor),
            articleTitle.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupImageViewConstraints() {
        addSubview(newImageView)
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newImageView.topAnchor.constraint(equalTo: moreButton.bottomAnchor),
            newImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            newImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        ])
    }
    
    public func configureCell(for savedArticle: Article) {
        currentArticle = savedArticle
        articleTitle.text = savedArticle.title
        
    }
    
}
