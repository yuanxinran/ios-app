//
//  Parsers.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/6/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI


func parseTripData(id: String, data: JSONDictionary, coverImage: Photo?, photoNum: Int, journalNum: Int, images: [String]) -> Trip? {
  
  if let title = data["title"] as? String, let travelPartners = data["travelPartners"] as? [String], let startDate = data["startDate"] as? Timestamp,let endDate = data["endDate"] as? Timestamp {
    
    let trip =  Trip(id: id, title: title, coverImage: coverImage, photoNum: photoNum, journalNum: journalNum, startDate: startDate.dateValue() as NSDate, endDate: endDate.dateValue() as NSDate, travelPartners: travelPartners, travelPartnerImages: images, latitude: 28.4813989, longitude: -81.5088355)
    
    return trip
  }
  return nil
}




func parsePhotoData(id: String, data: JSONDictionary) -> Photo? {
  var photoLocation : PhotoLocation?
  if let locationData = data["photoLocation"] as? [String:AnyObject], let geopoint = locationData["geocoding"] as? GeoPoint, let city = locationData["city"] as? String, let country = locationData["country"] as? String {
    let state = locationData["state"] as? String
    photoLocation = PhotoLocation(city: city,  state:state ?? "",  country: country, latitude: geopoint.latitude, longitude: geopoint.longitude)
  }
  if let dateTime = data["dateTime"] as? Timestamp, let imagePath = data["imagePath"] as? String {
    return Photo(id: id, dateTime: dateTime.dateValue() as NSDate, imagePath: imagePath, photoLocation: photoLocation)
  }
  return nil
}

func parseJournalData(id: String, data: JSONDictionary) -> Journal? {
  if let startColor = data["startColor"] as? String , let endColor = data["endColor"] as? String, let title = data["title"] as? String, let dateTime = data["dateTime"] as? Timestamp, let content = data["content"] as? String {
    
    let startColor = Color(startColor)
    let endColor = Color(endColor)
    return Journal(id: id, dateTime: dateTime.dateValue() as NSDate, title: title, content: content, gradientStart: startColor, gradientEnd: endColor)
  }
  return nil
}
