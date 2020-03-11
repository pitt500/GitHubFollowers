//
//  GFTabBarViewController.swift
//  GitHubFollowers
//
//  Created by projas on 3/11/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import UIKit

class GFTabBarViewController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UITabBar.appearance().tintColor = .systemGreen
    viewControllers = [
      createSearchNC(),
      creteFavoritesNC()
    ]
  }
  
  func createSearchNC() -> UINavigationController {
    let searchVC = SearchViewController()
    searchVC.title = "Search"
    searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
    
    return UINavigationController(rootViewController: searchVC)
  }
  
  func creteFavoritesNC() -> UINavigationController {
    let favoritesListVC = FavoritesListViewController()
    favoritesListVC.title = "Favorites"
    favoritesListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
    
    return UINavigationController(rootViewController: favoritesListVC)
  }
}
