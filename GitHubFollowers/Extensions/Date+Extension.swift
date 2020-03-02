//
//  Date+Extension.swift
//  GitHubFollowers
//
//  Created by projas on 3/2/20.
//  Copyright © 2020 pedrorojas.dev. All rights reserved.
//

import Foundation

extension Date {
  func convertToMonthYearFormat() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM yyyy"
    return dateFormatter.string(from: self)
  }
}
