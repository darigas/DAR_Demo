//
//  BottomNavigationController.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 8/8/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    let moviesItem: UITabBarItem = {
        let moviesItem = UITabBarItem()
        moviesItem.title = "Фильмы"
        moviesItem.image = UIImage(named: "movie")
        return moviesItem
    }()
    
    let cinemasItem: UITabBarItem = {
        let cinemasItem = UITabBarItem()
        cinemasItem.title = "Кинотеатры"
        cinemasItem.image = UIImage(named: "cinema")
        return cinemasItem
    }()
    
    let newsItem: UITabBarItem = {
        let newsItem = UITabBarItem()
        newsItem.title = "Новости"
        newsItem.image = UIImage(named: "news")
        return newsItem
    }()
    
    let profileItem: UITabBarItem = {
        let profileItem = UITabBarItem()
        profileItem.title = "Профиль"
        profileItem.image = UIImage(named: "profile")
        return profileItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        let moviesController = MoviesViewController()
        moviesController.tabBarItem = moviesItem
        
        let cinemasController = CinemasViewController()
        cinemasController.tabBarItem = cinemasItem
        
        let newsController = NewsViewController()
        newsController.tabBarItem = newsItem
        
        let profileController = ProfileViewController()
        profileController.tabBarItem = profileItem
        
        let controllers = [moviesController, cinemasController, newsController, profileController]
        self.viewControllers = controllers
    }
}
