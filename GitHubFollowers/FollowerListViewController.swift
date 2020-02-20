//
//  FollowerListViewController.swift
//  GitHubFollowers
//
//  Created by projas on 2/20/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import UIKit

class FollowerListViewController: UIViewController {
  
  var username: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    navigationController?.isNavigationBarHidden = false
    navigationController?.navigationBar.prefersLargeTitles = true
  }
}
