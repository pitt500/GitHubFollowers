//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by projas on 2/22/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import Foundation

class NetworkManager {
  static let shared = NetworkManager()
  let baseURL = "https://api.github.com"
  let perPage = 100
  
  private init() {}
  
  func getFollowers(for username: String, page: Int,
                    completion: @escaping (_ followers: [Follower]?, _ errorMessage: String?)->Void) {
    let endpoint = baseURL + "/users/\(username)/followers?per_page=\(perPage)&page=\(page)"
    
    guard let url = URL(string: endpoint) else {
      completion(nil, "This username created an invalid request. Please try again.")
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      
      if error != nil {
        completion(nil, "Unable to complete your request. Please check your internet connection")
        return
      }
      
      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        completion(nil, "Invalid response from server. Please try again.")
        return
      }
      
      guard let data = data else {
        completion(nil, "The data receive from server was invalid. Please try again.")
        return
      }
      
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let followers = try decoder.decode([Follower].self, from: data)
        completion(followers, nil)
      } catch {
        completion(nil, "The data receive from server was invalid. Please try again.")
      }
    }
    
    task.resume()
  }
}