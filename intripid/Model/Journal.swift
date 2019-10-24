//
//  Journal.swift
//  intripid
//
//  Created by Anna Yuan on 10/23/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation

class Journal{
  var dateTime: NSDate
  var title: String?
  var content: String
  var backgroundPicture: String?
  
  init(dateTime: NSDate, title: String?, content: String, backgroundPicture: String?){
    self.dateTime = dateTime
    self.title = title
    self.content = content
    self.backgroundPicture = backgroundPicture
  }
}
