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
    //Now we just give it a default location if the cover image doesn't have any location information
    var lat = 28.4813989
    var lng =  -81.5088355
    
    if let coverImage = coverImage, let imgLoc = coverImage.photoLocation{
      lat = imgLoc.latitude
      lng = imgLoc.longitude
     }
     
    let trip =  Trip(id: id, title: title, coverImage: coverImage, photoNum: photoNum, journalNum: journalNum, startDate: startDate.dateValue() as NSDate, endDate: endDate.dateValue() as NSDate, travelPartners: travelPartners, travelPartnerImages: images, latitude: lat, longitude: lng)
    
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


func parseTripDetailData(id: String, data: JSONDictionary, coverImage: Photo?, entries: [Entry], travelPartners: [TravelPartner]) -> TripDetail? {
  
  if let title = data["title"] as? String, let startDate = data["startDate"] as? Timestamp, let endDate = data["endDate"] as? Timestamp {
    
    var tripLocation : TripLocation
    if let coverImage = coverImage, let imgLoc = coverImage.photoLocation{
      tripLocation = TripLocation(city: imgLoc.city, state: imgLoc.state, country: imgLoc.country, latitude: imgLoc.latitude, longitude: imgLoc.longitude)
    } else {
      //now we just give it a default location if the cover image doesn't have any location information
      tripLocation = TripLocation(city: "Pittsburgh", state: "PA", country: "United States", latitude: 40.44062, longitude: -79.99589)
    }
    
    let trip = TripDetail(id: id, title: title, coverImage: coverImage, entries: entries, startDate: startDate.dateValue() as NSDate, endDate: endDate.dateValue() as NSDate, travelPartners: travelPartners, locations: [tripLocation])
    
     return trip
   }
  return nil
}

func parseTravelPartnerData(id: String, data: JSONDictionary) -> TravelPartner?{
  if let firstName = data["firstName"] as? String, let lastName =  data["lastName"] as? String{
    let partner = TravelPartner(id: id, firstName: firstName, lastName: lastName, profilePicture: data["profilePicture"] as? String ?? "")
    return partner
  } else {
    return nil
  }
  
}


