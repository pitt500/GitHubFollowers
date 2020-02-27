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
    NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success(let user):
        print(user)
      case .failure(let error):
        self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
      }
    }
  }
  
  @objc func dismissVC() {
    dismiss(animated: true)
  }
}
