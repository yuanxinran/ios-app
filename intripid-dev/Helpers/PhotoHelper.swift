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
import Alamofire
import SwiftyJSON


extension CLLocation {
  func fetchCityAndCountry(completion: @escaping (_ data: Data?, _ error: Error?) -> ()) {

 AF.request("https://maps.googleapis.com/maps/api/geocode/json?latlng=\(self.coordinate.latitude),\(self.coordinate.longitude)&key=AIzaSyB_osNVXW9q_VEdGDrpEo-XfYfzbb9729w").responseData { response in
      switch response.result {
      case .success(let value):
        print("printing the location result")
//        print(String(data: value, encoding: .utf8)!)
        
        completion(value, nil)
      case .failure(let error):
        print("Connection to gmap api failed.")
        completion(nil,error)
      }
    }
    
    
    
    
  }
  
}

extension PHAsset {
  func getLocationDataForPhoto(completion: @escaping (_ location: PhotoLocation?, _ error: Error?) -> ()){
    if let location = self.location {
      let lat = location.coordinate.latitude
      let lng = location.coordinate.longitude
      location.fetchCityAndCountry { data, error in
        guard let data = data else {
          print("Error")
          return
        }

        do {
          let swiftyjson = try JSON(data: data as Data)
          
          if let location = swiftyjson["results"][0]["address_componenets"].array {
            let locality = location[1]["short_name"]
            let level_2 = location[2]["short_name"]
            let level_1 = location[3]["short_name"]
            let country = location[4]["short_name"]
          }
        } catch {
            print("JSONSerialization error:", error)
        }
        print("city: \(city)")
        print("country: \(country)")
        guard let city = city, let country = country, error == nil else { return }
        completion(PhotoLocation(city: city, country: country, latitude: lat, longitude: lng), error)
      }
    }
  }
  
  
}




