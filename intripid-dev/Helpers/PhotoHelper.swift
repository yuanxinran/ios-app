//
//  LocationHelper.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/3/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import MapKit
import PhotosUI
import Photos


extension CLLocation {
  
  func geocode(completion: @escaping (_ placemarks: [CLPlacemark]?, _ error: Error?) -> Void)  {
    CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)) { placemark, error in
          guard let placemark = placemark, error == nil else {
              completion(nil, error)
              return
          }
          completion(placemark, nil)
      }
  }
}

extension PHAsset {
  func getLocationDataForPhoto(completion: @escaping (_ location: PhotoLocation?, _ error: Error?) -> ()){
    // if the photo has location information
    if let location = self.location {
      let lat = location.coordinate.latitude
      let lng = location.coordinate.longitude
      var country = ""
      var city = ""
      var state = ""
      location.geocode { placemarks, error in
        
        if let placemarks = placemarks, placemarks.count >= 0 {
          let place = placemarks[0]
          country = place.country ?? ""
          city = place.locality ?? (place.name ?? "")
          state = place.administrativeArea ?? ""
        }

        completion(PhotoLocation(city: city, state: state, country: country, latitude: lat, longitude: lng), error)
      }
    }
  }
  
  
}


