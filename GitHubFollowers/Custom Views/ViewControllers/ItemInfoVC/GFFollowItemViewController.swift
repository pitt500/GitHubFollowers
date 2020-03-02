//
//  GFFollowItemViewController.swift
//  GitHubFollowers
//
//  Created by projas on 3/2/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import UIKit

class GFFollowItemViewController: GFItemInfoViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureItems()
  }
  
  private func configureItems() {
    itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
    itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
    actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
  }
}

