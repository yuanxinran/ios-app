//
//  Journal.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/3/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import SwiftUI



struct Journal{
  var id: String
  var dateTime: NSDate
  var title: String
  var content: String
  var gradientStart: Color
  var gradientEnd: Color
}


extension Journal: Equatable {
  static func == (lhs: Journal, rhs: Journal) -> Bool {
     return lhs.id == rhs.id && lhs.dateTime == rhs.dateTime && lhs.title == rhs.title && lhs.content == rhs.content && lhs.gradientStart == rhs.gradientStart
  }
}

 
