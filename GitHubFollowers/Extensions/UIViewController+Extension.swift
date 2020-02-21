//
//  UIViewController+Extension.swift
//  GitHubFollowers
//
//  Created by projas on 2/21/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import UIKit

extension UIViewController {
  func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
    DispatchQueue.main.async {
      let alertVC = GFAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
      alertVC.modalPresentationStyle = .overFullScreen
      alertVC.modalTransitionStyle = .crossDissolve
      self.present(alertVC, animated: true)
    }
  }
}
