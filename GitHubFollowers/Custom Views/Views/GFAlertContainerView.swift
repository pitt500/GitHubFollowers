//
//  GFAlertContainerView.swift
//  GitHubFollowers
//
//  Created by projas on 3/12/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import UIKit

class GFAlertContainerView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure() {
    backgroundColor = .systemBackground
    layer.cornerRadius = 16
    layer.borderColor = UIColor.white.cgColor
    layer.borderWidth = 2
    translatesAutoresizingMaskIntoConstraints = false
  }
}
