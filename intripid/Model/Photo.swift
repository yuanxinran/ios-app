//
//  Photo.swift
//  intripid
//
//  Created by Anna Yuan on 10/22/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation


struct PhotoLocation {
  var city: String
  var state: String
  var country: String
  var latidude: Double
  var longitude: Double
  
}
struct Photo {
  var dateTime: NSDate
  var imagePath: String
  var photoLocation: PhotoLocation
}
