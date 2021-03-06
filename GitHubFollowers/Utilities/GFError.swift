//
//  GFError.swift
//  GitHubFollowers
//
//  Created by projas on 2/22/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import Foundation

enum GFError: String, Error {
  case invalidUsername = "This username created an invalid request. Please try again."
  case unableToComplete = "Unable to complete your request. Please check your internet connection"
  case invalidResponse = "Invalid response from server. Please try again."
  case invalidData = "The data receive from server was invalid. Please try again."
  case unableToFavorite = "There was an error. Please try again."
  case alreadyInFavorites = "You already favorited this user. You must REALLY like them!"
}
