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
  var photos: [Photo]
  var journals: [Journal]
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

extension Trip: Equatable {
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        return
            lhs.docID == rhs.docID &&
            lhs.title == rhs.title
    }
}

// TODO: get the trips from the API
let tripsData = [
  Trip(id: "trip1",
       title: "Florida",
       startDate: NSDate(),
       endDate: NSDate(),
       photos: photosData.shuffled(),
       travelPartners: [],
       travelPartnerImages: [],
       latitude: 28.4813989,
       longitude: -81.5088355),
  Trip(id: "trip1",
       title: "Hawaii",
       startDate: NSDate(),
       endDate: NSDate(),
       photos: photosData.shuffled(),
       travelPartners: [],
       travelPartnerImages: [],
       latitude: 21.3281792,
       longitude: -157.8691135),
  Trip(id: "trip1",
       title: "Pittsburgh",
       startDate: NSDate(),
       endDate: NSDate(),
       photos: photosData.shuffled(),
       travelPartners: [],
       travelPartnerImages: [],
       latitude: 40.431478,
       longitude: -80.0505405),
  Trip(id: "trip1",
       title: "Miami",
       startDate: NSDate(),
       endDate: NSDate(),
       photos: photosData.shuffled(),
       travelPartners: [],
       travelPartnerImages: [],
       latitude: 25.7825453,
       longitude: -80.2994988)
]

let photosData = ["picture_1", "picture_2", "picture_3", "picture_4", "picture_5", "picture_6", "picture_7", "picture_8", "picture_9", "picture_10", "picture_11", "picture_12", "picture_13", "picture_14", "picture_15", "picture_16", "picture_17", "picture_18", "picture_19", "picture_20"]



func createTripSkeleton(title: String, travelPartners: [String], photos: [PHAsset], coverImage: Int, completion: @escaping (_ result:String?) -> Void){
  var ref: DocumentReference? = nil
  var docID: String? = nil
  //TODO: ADD PHOTOS TO THE CLOUD STORAGE
  ref = Firestore.firestore().collection("trips").addDocument(data: [
    "title": title,
    "travelPartners": travelPartners,
  ]) { err in
    if let err = err {
      print("Error adding document: \(err)")
    } else {
      print("Trip added with ID: \(ref!.documentID)")
      
      docID = ref?.documentID
      completion(docID)
    }
  }
  
}
