//
//  FavoritesListViewController.swift
//  GitHubFollowers
//
//  Created by projas on 2/19/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import UIKit

class FavoritesListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      view.backgroundColor = .systemBackground
      
      PersistanceManager.retrieveFavorites { result in
        switch result {
        case .success(let favorites):
          print(favorites)
        case .failure(let error):
          print(error)
        }
      }
    }
}
