//
//  FollowerCell.swift
//  GitHubFollowers
//
//  Created by projas on 2/24/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import UIKit

class FollowerCell: BaseCollectionCell {
  let avatarImageView = GFAvatarImageView(frame: .zero)
  let usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureAvatar()
    configureLabel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func set(follower: Follower) {
    usernameLabel.text = follower.login
    NetworkManager.shared.downloadImage(from: follower.avatarUrl) { [weak self] image in
      guard let self = self else { return }
      DispatchQueue.main.async { self.avatarImageView.image = image }
    }
  }
  
  private func configureAvatar() {
    addSubview(avatarImageView)
    
    let padding: CGFloat = 8
    
    NSLayoutConstraint.activate([
      avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
      avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
      avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
    ])
  }
  
  private func configureLabel() {
    addSubview(usernameLabel)
    
    let padding: CGFloat = 8
    
    NSLayoutConstraint.activate([
      usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
      usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
      usernameLabel.heightAnchor.constraint(equalToConstant: 20)
    ])
  }
}
