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


struct TripDetail: Identifiable {
  var id = UUID()
  var docID: String
  var title: String
  var coverImage: Photo?
  var photoNum = 0
  var journalNum = 0
  var startDate: NSDate
  var endDate: NSDate
  var photos: [String]? // TODO: fix this
  var travelPartners: [String]
  var travelPartnerImages: [String]
}


struct Trip: Identifiable {
  var id = UUID()
  var docID: String
  var title: String
  var coverImage: Photo?
  var photoNum = 0
  var journalNum = 0
  var startDate: NSDate
  var endDate: NSDate
  var photos: [String]? // TODO: fix this
  var travelPartners: [String]
  var travelPartnerImages: [String]
}

// TODO: get the trips from the API
let tripsData = [
  Trip(docID: "trip1",
       title: "Florida",
       startDate: NSDate(),
       endDate: NSDate(),
       photos: photosData.shuffled(),
       travelPartners: [],
       travelPartnerImages: []),
  Trip(docID: "trip1",
       title: "Hawaii",
       startDate: NSDate(),
       endDate: NSDate(),
       photos: photosData.shuffled(),
       travelPartners: [],
       travelPartnerImages: []),
  Trip(docID: "trip1",
       title: "Pittsburgh",
       startDate: NSDate(),
       endDate: NSDate(),
       photos: photosData.shuffled(),
       travelPartners: [],
       travelPartnerImages: []),
  Trip(docID: "trip1",
       title: "Miami",
       startDate: NSDate(),
       endDate: NSDate(),
       photos: photosData.shuffled(),
       travelPartners: [],
       travelPartnerImages: [])
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
