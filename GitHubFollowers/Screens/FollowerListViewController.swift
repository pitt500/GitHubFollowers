//
//  FollowerListViewController.swift
//  GitHubFollowers
//
//  Created by projas on 2/20/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import UIKit

protocol FollowerListVCDelegate: class {
  func didRequestFollowers(for username: String)
}

class FollowerListViewController: GFDataLoadingViewController {
  
  enum Section {
    case main
  }
  
  var username: String!
  var followers: [Follower] = []
  var filterFollowers: [Follower] = []
  var page = 1
  var hasMoreFollowers = true
  var isSearching = false
  
  var collectionView: UICollectionView!
  var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
  
  init(username: String) {
    super.init(nibName: nil, bundle: nil)
    self.username = username
    title = username
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureSearchController()
    configureCollectionView()
    getFollowers(username: username, page: page)
    configureDataSource()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  func configureViewController() {
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.prefersLargeTitles = true
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    navigationItem.rightBarButtonItem = addButton
  }
  
  func configureCollectionView() {
    collectionView = UICollectionView(frame: view.bounds,
                                      collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
    view.addSubview(collectionView)
    
    collectionView.delegate = self
    collectionView.backgroundColor = .systemBackground
    collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseIdentifier)
  }
  
  func configureSearchController() {
    let searchController = UISearchController()
    searchController.searchResultsUpdater = self
    searchController.searchBar.placeholder = "Search for a username"
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
    navigationItem.searchController = searchController
  }
  
  func getFollowers(username: String, page: Int) {
    showLoadingView()
    NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
      self?.dismissLoadingView()
      guard let self = self else { return }
    
         switch result {
         case .success(let followers):
          self.followers.append(contentsOf: followers)
          self.hasMoreFollowers = followers.count >= 100
          
          if self.followers.isEmpty {
            let message = "This user doesn't have any followers. Go follow them😄!"
            DispatchQueue.main.async {
              self.showEmptyStateView(with: message, in: self.view)
              return
            }
          }
          
          self.updateData(on: self.followers)
           
         case .failure(let error):
           self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "Ok")
         }
       }
  }
  
  func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseIdentifier, for: indexPath) as! FollowerCell
      
      cell.set(follower: follower)
      
      return cell
    })
  }
  
  func updateData(on followers: [Follower]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
    snapshot.appendSections([.main])
    snapshot.appendItems(followers)
    
    DispatchQueue.main.async {
      self.dataSource.apply(snapshot, animatingDifferences: true)
      self.updateSearchResults(for: self.navigationItem.searchController!)
    }
  }
  
  @objc func addButtonTapped() {
    showLoadingView()
    
    NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
      guard let self = self else { return }
      self.dismissLoadingView()
      
      switch result {
      case .success(let user):
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistanceManager.update(with: favorite, actionType: .add) { error in
          guard let error = error else {
            self.presentGFAlertOnMainThread(title: "Success", message: "You have successfully favorited this user 🎉", buttonTitle: "Hooray!")
            return
          }
          
          self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
        
      case .failure(let error):
        self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
      }
    }
  }
}

extension FollowerListViewController: UICollectionViewDelegate {
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let height  = scrollView.frame.size.height
    
    if offsetY > contentHeight - height {
      guard hasMoreFollowers else { return }
      page += 1
      getFollowers(username: username, page: page)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let activeArray = isSearching ? filterFollowers: followers
    let follower = activeArray[indexPath.item]
    
    let destinationVC = UserInfoViewController()
    destinationVC.username = follower.login
    destinationVC.delegate = self
    let navVC = UINavigationController(rootViewController: destinationVC)
    present(navVC, animated: true)
  }
}

extension FollowerListViewController: UISearchResultsUpdating, UISearchBarDelegate {
  func updateSearchResults(for searchController: UISearchController) {
    guard let filter = searchController.searchBar.text, !filter.isEmpty else {
      return
    }
    isSearching = true
    filterFollowers = followers.filter { $0.login.contains(filter.lowercased()) }
    updateData(on: filterFollowers)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    isSearching = false
    updateData(on: self.followers)
  }
}

extension FollowerListViewController: FollowerListVCDelegate {
  func didRequestFollowers(for username: String) {
    self.username = username
    title = username
    page = 1
    followers.removeAll()
    filterFollowers.removeAll()
    
    collectionView.setContentOffset(.zero, animated: true)
    getFollowers(username: username, page: page)
  }
}
