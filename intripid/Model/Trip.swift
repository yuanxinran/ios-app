//
//  Trip.swift
//  intripid
//
//  Created by Anna Yuan on 10/22/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation

class Trip {
  var title: String
  var travelPartners : [String]
  var journals: [Journal]
  var photos: [Photo]
  var startDate: NSDate
  var endDate: NSDate
  
  init(title: String, travelPartners: [String]?, journals: [Journal]?, photos: [Photo]?, startDate: NSDate, endDate: NSDate){
    self.title = title
    self.travelPartners = travelPartners ?? []
    self.journals = journals ?? []
    self.photos = photos ?? []
    self.startDate = startDate
    self.endDate = endDate
  }
}
