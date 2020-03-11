//
//  FavoritesListViewController.swift
//  GitHubFollowers
//
//  Created by projas on 2/19/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import UIKit

class FavoritesListViewController: UIViewController {
  
  let tableView = UITableView()
  var favorites: [Follower] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViewController()
    configureTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getFavorites()
  }
  
  func configureViewController() {
    view.backgroundColor = .systemBackground
    title =  "Favorites"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  func configureTableView() {
    view.addSubview(tableView)
    
    tableView.frame = view.bounds
    tableView.rowHeight = 80
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
    
    tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseIdentifier)
  }
  
  func getFavorites() {
    PersistanceManager.retrieveFavorites { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success(let favorites):
        if favorites.isEmpty  {
          self.showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen", in: self.view)
        } else {
          self.favorites = favorites
          DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
          }
        }
        
      case .failure(let error):
        self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
      }
    }
  }
  
}

extension FavoritesListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favorites.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseIdentifier, for: indexPath) as! FavoriteCell
    cell.set(favorite: favorites[indexPath.row])
    
    return cell
  }
  
  
}

extension FavoritesListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let favorite = favorites[indexPath.row]
    let destVC = FollowerListViewController(username: favorite.login)
    navigationController?.pushViewController(destVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else {
      return
    }
    
    let favorite = favorites[indexPath.row]
    favorites.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .left)
    
    if favorites.isEmpty  {
      self.showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen", in: self.view)
    }
    
    tableView.reloadData()
    
    PersistanceManager.update(with: favorite, actionType: .remove) { [weak self] error in
      guard let self = self else { return }
      guard let error = error else { return }
      
      self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
    }
  }
}
