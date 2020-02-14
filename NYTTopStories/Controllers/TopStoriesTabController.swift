//
//  TopStoriesTabController.swift
//  NYTTopStories
//
//  Created by Matthew Ramos on 2/6/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import DataPersistence

class TopStoriesTabController: UITabBarController {
    
    //1
    private var dataPersistence = DataPersistence<Article>(filename: "savedArticles.plist")
    
    private lazy var newsFeedVC: NewsFeedViewController = {
        let viewController = NewsFeedViewController(dataPersistence)
        viewController.tabBarItem = UITabBarItem(title: "News Feed", image: UIImage(systemName: "eyeglasses"), tag: 0)
        return viewController
    }()
    
    private lazy var savedArticlesVC: SavedArticleViewController = {
        let viewController = SavedArticleViewController(dataPersistence)
        viewController.tabBarItem = UITabBarItem(title: "Saved Articles", image: UIImage(systemName: "folder"), tag: 1)
        return viewController
    }()
    
    private lazy var settingsVC: SettingsViewController = {
        let viewController = SettingsViewController()
        viewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        
        viewControllers = [UINavigationController(rootViewController: newsFeedVC), UINavigationController(rootViewController: savedArticlesVC), settingsVC]

    }

}
