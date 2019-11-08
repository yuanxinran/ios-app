//
//  Trip.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/28/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Photos
import PhotosUI
//
//
struct TripDetail: Identifiable {
  var id: String
  var title: String
  var coverImage: Photo?
  var entries: [Entry]
  var startDate: NSDate
  var endDate: NSDate
  var travelPartners: [TravelPartner]
  var locations: [TripLocation]
}

struct TripLocation: Identifiable {
  var id = UUID()
  var city: String
  var state: String
  var country: String
  var latitude: Double
  var longitude: Double
}

extension TripLocation: Equatable {
  static func == (lhs: TripLocation, rhs: TripLocation) -> Bool {
    return lhs.city == rhs.city &&
        lhs.state == rhs.state &&
        lhs.country == rhs.country &&
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
  }
}




extension TripDetail: Equatable {
  static func == (lhs: TripDetail, rhs: TripDetail) -> Bool {
    return
      lhs.id == rhs.id && lhs.title == rhs.title && lhs.coverImage == rhs.coverImage && lhs.entries == rhs.entries && lhs.startDate == rhs.startDate && lhs.endDate == rhs.endDate && lhs.travelPartners == rhs.travelPartners
  }
}

struct Trip: Identifiable {
  var id :String
  var title: String
  var coverImage: Photo?
  var photoNum = 0
  var journalNum = 0
  var startDate: NSDate
  var endDate: NSDate
  var photos: [String]? // TODO: fix this
  var travelPartners: [String]
  var travelPartnerImages: [String]
  var latitude: Double
  var longitude: Double
}

extension Trip: Equatable{
  static func == (lhs: Trip, rhs: Trip) -> Bool {
    return
      lhs.id == rhs.id &&
        lhs.title == rhs.title
  }

}

extension Trip: Comparable {
static func < (lhs: Trip, rhs: Trip) -> Bool {
    if lhs.startDate.timeIntervalSinceReferenceDate < rhs.startDate.timeIntervalSinceReferenceDate {
      return true
    } else if lhs.startDate.timeIntervalSinceReferenceDate == rhs.startDate.timeIntervalSinceReferenceDate {
      return lhs.endDate.timeIntervalSinceReferenceDate < rhs.endDate.timeIntervalSinceReferenceDate
    } else {
      return false
    }
}
}

//// TODO: get the trips from the API
//let tripsData = [
//  Trip(id: "trip1",
//       title: "Florida",
//       startDate: NSDate(),
//       endDate: NSDate(),
//       photos: photosData.shuffled(),
//       travelPartners: [],
//       travelPartnerImages: [],
//       latitude: 28.4813989,
//       longitude: -81.5088355),
//  Trip(id: "trip1",
//       title: "Hawaii",
//       startDate: NSDate(),
//       endDate: NSDate(),
//       photos: photosData.shuffled(),
//       travelPartners: [],
//       travelPartnerImages: [],
//       latitude: 21.3281792,
//       longitude: -157.8691135),
//  Trip(id: "trip1",
//       title: "Pittsburgh",
//       startDate: NSDate(),
//       endDate: NSDate(),
//       photos: photosData.shuffled(),
//       travelPartners: [],
//       travelPartnerImages: [],
//       latitude: 40.431478,
//       longitude: -80.0505405),
//  Trip(id: "trip1",
//       title: "Miami",
//       startDate: NSDate(),
//       endDate: NSDate(),
//       photos: photosData.shuffled(),
//       travelPartners: [],
//       travelPartnerImages: [],
//       latitude: 25.7825453,
//       longitude: -80.2994988)
//]
//
//let photosData = ["picture_1", "picture_2", "picture_3", "picture_4", "picture_5", "picture_6", "picture_7", "picture_8", "picture_9", "picture_10", "picture_11", "picture_12", "picture_13", "picture_14", "picture_15", "picture_16", "picture_17", "picture_18", "picture_19", "picture_20"]
//
//
