//
//  UserInfoViewController.swift
//  GitHubFollowers
//
//  Created by projas on 2/27/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import UIKit

protocol UserInfoVCDelegate: class {
  func didTapGitHubProfile(for user: User)
  func didTapGetFollowers(for user: User)
}

class UserInfoViewController: GFDataLoadingViewController {
  
  let headerView = UIView()
  let itemViewOne = UIView()
  let itemViewTwo = UIView()
  let dateLabel = GFBodyLabel(textAlignment: .center)
  var itemViews: [UIView] = []
  
  var username: String!
  weak var delegate: FollowerListVCDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    layoutUI()
    getUserInfo()

  }
  
  func configureViewController() {
    view.backgroundColor = .systemBackground
    let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
    navigationItem.rightBarButtonItem = done
  }
  
  func getUserInfo() {
    NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success(let user):
        DispatchQueue.main.async { self.configureUIElements(with: user) }
      case .failure(let error):
        self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
      }
    }
  }
  
  func configureUIElements(with user: User) {
    
    let repoItemVC = GFRepoItemViewController(user: user)
    repoItemVC.delegate = self
    
    let followItemVC = GFFollowItemViewController(user: user)
    followItemVC.delegate = self
    
    let headerVC = GFUserInfoHeaderViewController(user: user)
    
    self.add(childViewController: headerVC, to: self.headerView)
    self.add(childViewController: repoItemVC, to: self.itemViewOne)
    self.add(childViewController: followItemVC, to: self.itemViewTwo)
    self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
  }
  
  func layoutUI() {
    
    itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
    let padding: CGFloat = 20
    let itemHeight: CGFloat = 140
    
    for itemView in itemViews {
      view.addSubview(itemView)
      itemView.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
        itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
        itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
      ])
    }
    
    NSLayoutConstraint.activate([
      headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 180),
      
      itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
      itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
      
      itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
      itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
      
      dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
      dateLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }
  
  func add(childViewController: UIViewController, to containerView: UIView) {
    addChild(childViewController)
    containerView.addSubview(childViewController.view)
    childViewController.view.frame = containerView.bounds
    childViewController.didMove(toParent: self)
  }
  
  @objc func dismissVC() {
    dismiss(animated: true)
  }
}

extension UserInfoViewController: UserInfoVCDelegate {
  func didTapGitHubProfile(for user: User) {
    
    guard let url = URL(string: user.htmlUrl) else {
      presentGFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid.", buttonTitle: "Ok")
      return
    }
    
    presentSafariVC(with: url)
  }
  
  func didTapGetFollowers(for user: User) {
    
    guard user.followers > 0 else {
      presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers. What a shame 😞.", buttonTitle: "Ok")
      return
    }
    
    delegate?.didRequestFollowers(for: user.login)
    dismissVC()
  }
  
  
}
