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
  var state: String
  var country: String
  var latitude: Double
  var longitude: Double
  
}

extension PhotoLocation: Equatable {
    static func == (lhs: PhotoLocation, rhs: PhotoLocation) -> Bool {
        return
            lhs.city == rhs.city &&
            lhs.country == rhs.country &&
            lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude
    }
}

struct Photo : Identifiable {
  var id: String
  var dateTime: NSDate
  var imagePath: String
  var imagePathHQ: String?
  var photoLocation: PhotoLocation?
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return
            lhs.imagePath == rhs.imagePath
    }
}






      
  

