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
//          print("country : \(place.country ?? "")")
//          print("city : \(place.locality ?? "")")
//          print("name : \(place.name ?? "")")
//          print("state : \(place.administrativeArea ?? "")")
//          print("sub: \(place.subAdministrativeArea ?? "")")
          
          country = place.country ?? ""
          city = place.locality ?? (place.name ?? "")
          state = place.administrativeArea ?? ""
        }

//        guard let city = city, let country = country, error == nil else { return }
        completion(PhotoLocation(city: city, state: state, country: country, latitude: lat, longitude: lng), error)
      }
    }
  }
  
  
}





//guard let data = data else {
//  print("Error")
//  return
//}
//
//let cityLong = ""
//let cityShort = ""
//let countryLong = ""
//let countryShort = ""
//
//do {
//  let swiftyjson = try JSON(data: data as Data)
//
//  if let locations = swiftyjson["results"][0]["address_componenets"].array {
//    for locjson in locations {
//      let longName = ""
//      let type = locjson["types"].array![0].string!
//      if type == "country"{
//
//      }
//    }
//  }
//} catch {
//    print("JSONSerialization error:", error)
//}



