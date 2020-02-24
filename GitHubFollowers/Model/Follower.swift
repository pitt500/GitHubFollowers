//
//  Follower.swift
//  GitHubFollowers
//
//  Created by projas on 2/22/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import Foundation

struct Follower: Codable, Hashable {
  var login: String
  var avatarUrl: String
}
