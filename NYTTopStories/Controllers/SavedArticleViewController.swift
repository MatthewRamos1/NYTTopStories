//
//  SavedArticleViewController.swift
//  NYTTopStories
//
//  Created by Matthew Ramos on 2/6/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import DataPersistence

class SavedArticleViewController: UIViewController {
    
    //4
    private var dataPersistence: DataPersistence<Article>
    private let savedArticleView = SavedArticleView()
    
    private var savedArticles = [Article]() {
        didSet {
            savedArticleView.collectionView.reloadData()
            if savedArticles.isEmpty {
                savedArticleView.collectionView.backgroundView = EmptyView(title: "Saved Articles", message: "There are currently no saved articles. Start browsing by tapping on the news icon.")
            } else {
                savedArticleView.collectionView.backgroundView = nil
            }
        }
    }
    
    init(_ dataPersistence: DataPersistence<Article>) {
        self.dataPersistence = dataPersistence
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = savedArticleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        fetchSavedArticles()
        savedArticleView.collectionView.dataSource = self
        savedArticleView.collectionView.delegate = self
        savedArticleView.collectionView.register(SavedArticleCell.self, forCellWithReuseIdentifier: "savedArticleCell")

    }
    
    
    private func fetchSavedArticles() {
        do {
            savedArticles = try dataPersistence.loadItems()
        } catch {
            print("Error")
        }
    }
}

extension SavedArticleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        savedArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedArticleCell", for: indexPath) as? SavedArticleCell else {
            fatalError("Could not downcast to a SavedArticleCell")
        }
        let savedArticle = savedArticles[indexPath.row]
        cell.backgroundColor = .white
        cell.configureCell(for: savedArticle)
        cell.delegate = self
        return cell
    }
    
    
}

extension SavedArticleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemHeight: CGFloat = maxSize.height * 0.30
        let numberOfItems: CGFloat = 2
        let spacing: CGFloat = 10
        let totalSpacing :CGFloat = (2 * spacing) + (numberOfItems - 1) * spacing
        let itemWidth: CGFloat = (maxSize.width - totalSpacing) / numberOfItems
        return CGSize(width: itemWidth, height: itemHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = savedArticles[indexPath.row]
        let detailVC = ArticleDetailViewController(dataPersistence, article: article)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

//5
extension SavedArticleViewController: DataPersistenceDelegate {
    func didSaveItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        fetchSavedArticles()
    }
    
    func didDeleteItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        fetchSavedArticles()
    }
}

extension SavedArticleViewController: SavedArticleCellDelegate {
    func didSelectMoreButton(_ savedArticleCell: SavedArticleCell, article: Article) {
         print("didSelect")
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { alertAction in
            self.deleteArticle(article)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true)
    }
    
    private func deleteArticle(_ article: Article) {
        guard let index = savedArticles.firstIndex(of: article) else {
            return
        }
        do {
            try dataPersistence.deleteItem(at: index)
        } catch {
            print("error deleting article")
        }
    }
}
