//
//  GFRepoItemViewController.swift
//  GitHubFollowers
//
//  Created by projas on 3/2/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import UIKit

class GFRepoItemViewController: GFItemInfoViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureItems()
  }
  
  private func configureItems() {
    itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
    itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
    actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
  }
  
  override func actionButtonTapped() {
    delegate?.didTapGitHubProfile(for: user)
  }
}
