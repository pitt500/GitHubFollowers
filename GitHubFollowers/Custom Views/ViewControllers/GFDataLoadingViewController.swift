//
//  GFDataLoadingViewController.swift
//  GitHubFollowers
//
//  Created by projas on 3/12/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import UIKit

class GFDataLoadingViewController: UIViewController {
  
  var containerView: UIView!
  
  func dismissLoadingView() {
    DispatchQueue.main.async {
      self.containerView.removeFromSuperview()
      self.containerView = nil
    }
  }
  
  func showEmptyStateView(with message: String, in view: UIView) {
    let emptyStateView = CFEmptyStateView(message: message)
    emptyStateView.frame = view.bounds
    view.addSubview(emptyStateView)
  }
  
  func showLoadingView() {
    containerView = UIView(frame: view.bounds)
    view.addSubview(containerView)
    
    containerView.backgroundColor = .systemBackground
    containerView.alpha = 0.0
    
    UIView.animate(withDuration: 0.25, animations:  {
      self.containerView.alpha = 0.8
    })
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    containerView.addSubview(activityIndicator)
    
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
    
    activityIndicator.startAnimating()
  }
}
