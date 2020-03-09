//
//  BaseCell.swift
//  GitHubFollowers
//
//  Created by projas on 2/24/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell {
  static var reuseIdentifier: String {
    String(describing: self)
  }
}

class BaseCell: UITableViewCell {
  static var reuseIdentifier: String {
    String(describing: self)
  }
}
