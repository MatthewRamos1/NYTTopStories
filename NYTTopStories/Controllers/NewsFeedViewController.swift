//
//  NewsFeedViewController.swift
//  NYTTopStories
//
//  Created by Matthew Ramos on 2/6/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import DataPersistence

struct UserKey {
    static let newsSection = "News Section"
    static let sectionName = "Section Name"
}

class NewsFeedViewController: UIViewController {
    
    private let newsFeedView = NewsFeedView()
    
    private var sectionName = "Technology" {
        didSet {
            
        }
    }
    
    //2
    private var dataPersistence: DataPersistence<Article>
    
    private var newsArticles = [Article]() {
        didSet {
            DispatchQueue.main.async {
                self.newsFeedView.collectionView.reloadData()
            }
        }
    }
    
    init(_ dataPersistence: DataPersistence<Article>!) {
        self.dataPersistence = dataPersistence
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        newsFeedView.collectionView.dataSource = self
        newsFeedView.collectionView.delegate = self
        newsFeedView.searchBar.delegate = self
        
        newsFeedView.collectionView.register(NewsCell.self, forCellWithReuseIdentifier: "articleCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchStories()
    }
    
    override func loadView() {
        view = newsFeedView
    }


    private func fetchStories(for section: String = "Technology") {
        
        if let sectionName = UserDefaults.standard.object(forKey: UserKey.sectionName) as? String {
            if sectionName != self.sectionName {
                queryAPI(for: sectionName)
            }
        } else {
            queryAPI(for: sectionName)
        }
    }
    
    private func queryAPI(for section: String) {
        NYTTopStoriesAPIClient.fetchTopStories(for: section) { [weak self] (result) in
                switch result {
                    case .failure(let appError):
                    print("Error fetching stories: \(appError)")
                case .success(let articles):
                    self?.newsArticles = articles
                }
            }
        }
    }

extension NewsFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as? NewsCell else {
            fatalError("Could not downcast to NewsCell")
        }
        
        let article = newsArticles[indexPath.row]
        cell.configureCell(with: article)
        cell.backgroundColor = .white
        return cell
    }
    
    
}
extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width
        let itemHeight: CGFloat = maxSize.height * 0.30
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = newsArticles[indexPath.row]
        let articleDVC = ArticleDetailViewController(dataPersistence, article: article)
        
        //3
        navigationController?.pushViewController(articleDVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if newsFeedView.searchBar.isFirstResponder {
            newsFeedView.searchBar.resignFirstResponder()
        }
    }
}

extension NewsFeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            fetchStories()
            return
        }
        newsArticles = newsArticles.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }
}
