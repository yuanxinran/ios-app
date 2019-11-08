//
//  Entry.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/8/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation



struct Entry{
  var journal : Journal?
  var photo : Photo?
  var type : String
  
  func getDateTime() -> NSDate{
    switch (self.journal, self.photo) {
    case let (.none, .some(photo)):
      return photo.dateTime
    case let (.some(journal), .none):
      return journal.dateTime
    default:
      return NSDate()
    }
  }
  
  func getDocID() -> String{
     switch (self.journal, self.photo) {
     case let (.none, .some(photo)):
       return photo.id
     case let (.some(journal), .none):
       return journal.id
     default:
       return "noid"
     }
   }
   
}



extension Entry: Equatable {
  static func == (lhs: Entry, rhs: Entry) -> Bool {
    lhs.getDateTime() == lhs.getDateTime() && lhs.type == rhs.type && lhs.getDocID() == rhs.getDocID()
  }
  

  static func < (lhs: Entry, rhs: Entry) -> Bool {
    return lhs.getDateTime().timeIntervalSinceReferenceDate < rhs.getDateTime().timeIntervalSinceReferenceDate
  }
  
}
