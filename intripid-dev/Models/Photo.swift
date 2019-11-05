//
//  Photo.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/3/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import Photos
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage


struct PhotoLocation {
  var city: String
  var country: String
  var latitude: Double
  var longitude: Double
  
}
struct Photo {
  var dateTime: NSDate
  var imagePath: String
  var photoLocation: PhotoLocation
}






      
  

