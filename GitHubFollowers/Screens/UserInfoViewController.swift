//
//  UserInfoViewController.swift
//  GitHubFollowers
//
//  Created by projas on 2/27/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {
  
  var username: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
    navigationItem.rightBarButtonItem = done
    print(username!)
  }
  
  @objc func dismissVC() {
    dismiss(animated: true)
  }
}
