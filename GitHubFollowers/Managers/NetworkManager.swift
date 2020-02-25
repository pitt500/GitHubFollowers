//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by projas on 2/22/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import UIKit

class NetworkManager {
  static let shared = NetworkManager()
  private let baseURL = "https://api.github.com"
  private let perPage = 100
  let cache = NSCache<NSString, UIImage>()
  
  private init() {}
  
  func getFollowers(for username: String, page: Int,
                    completion: @escaping (_ result: Result<[Follower], GFError>)->Void) {
    let endpoint = baseURL + "/users/\(username)/followers?per_page=\(perPage)&page=\(page)"
    
    guard let url = URL(string: endpoint) else {
      completion(.failure(.invalidUsername))
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      
      if error != nil {
        completion(.failure(.unableToComplete))
        return
      }
      
      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        completion(.failure(.invalidResponse))
        return
      }
      
      guard let data = data else {
        completion(.failure(.invalidData))
        return
      }
      
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let followers = try decoder.decode([Follower].self, from: data)
        completion(.success(followers))
      } catch {
        completion(.failure(.invalidData))
      }
    }
    
    task.resume()
  }
}
