//
//  TripViewModel.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/5/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore

typealias JSONDictionary = [String: Any]

func parseTripData(id: String, data: JSONDictionary, coverImage: Photo?, photoNum: Int, journalNum: Int, images: [String]) -> Trip? {
  
  if let title = data["title"] as? String, let travelPartners = data["travelPartners"] as? [String], let startDate = data["startDate"] as? Timestamp,let endDate = data["endDate"] as? Timestamp{
    let trip =  Trip(docID: id, title: title, coverImage: coverImage, photoNum: photoNum, journalNum: journalNum, startDate: startDate.dateValue() as NSDate, endDate: endDate.dateValue() as NSDate, travelPartners: travelPartners, travelPartnerImages: images, latitude: 28.4813989, longitude: -81.5088355)
    
    return trip
  }
  return nil
}

func parsePhotoData(id: String, data: JSONDictionary) -> Photo? {
  var photoLocation : PhotoLocation?
  if let locationData = data["photoLocation"] as? [String:AnyObject], let geopoint = locationData["geocoding"] as? GeoPoint, let city = locationData["city"] as? String, let country = locationData["country"] as? String {
    
    photoLocation = PhotoLocation(city: city, country: country, latitude: geopoint.latitude, longitude: geopoint.longitude)
  }
  if let dateTime = data["dateTime"] as? Timestamp, let imagePath = data["imagePath"] as? String {
    return Photo(dateTime: dateTime.dateValue() as NSDate, imagePath: imagePath, photoLocation: photoLocation)
  }
  return nil
}

class TripViewModel: ObservableObject {
  @Published var trips = [Trip]()
  var userID :  String
  var db: Firestore!
  
  
  func fetchCoverPhoto(tripID: String ,documentID: String, completion: @escaping (Photo?) -> ()){
    var result : Photo?
    let photoRef = db.collection("trips").document(tripID).collection("photos").document(documentID)
    photoRef.getDocument { (document, error) in
      if let document = document, document.exists {
        if let data = document.data(), let photo = parsePhotoData(id: document.documentID, data:data) {
          result = photo
        }
      } else {
        print("Document does not exist")
      }
      completion(result)
    }
  }
  
  func fetchPhotoJournals(tripID: String, completion: @escaping (Int, Int) -> ()){
    var photoNum = 0
    var journalNum = 0
    let tripRef = db.collection("trips").document(tripID)
    tripRef.collection("photos").getDocuments(){ (querySnapshot, err) in
      if let err = err {
        print("Error getting photo number in trip: \(err)")
      } else {
        photoNum = querySnapshot!.documents.count
      }
      tripRef.collection("journals").getDocuments(){ (querySnapshot, err) in
        if let err = err {
          print("Error getting documents: \(err)")
        } else {
          journalNum = querySnapshot!.documents.count
        }
        completion(photoNum, journalNum)
      }
    }
  }
  
  func fetchTravelPartnerPhoto(travelPartnerID: [String], completion: @escaping ([String]) -> ()){
    var result = [String]()
    let dispatchGroup = DispatchGroup()
    let partnerCollection = db.collection("users").document(self.userID).collection("travelPartners")
    for id in travelPartnerID {
      dispatchGroup.enter()
      let ref = partnerCollection.document(id)
      ref.getDocument { (document, error) in
        if let document = document, document.exists {
          if let data = document.data(), let imageURL = data["profilePicture"] as? String {
            print("Getting the imageURL: \(imageURL)")
            result.append(imageURL)
          }
        } else {
          result.append("")
        }
        dispatchGroup.leave()
      }
    }
    
    dispatchGroup.notify(queue: DispatchQueue.global()) {
      print("complete fetching images for all travel partners")
      completion(result)
    }
  }
  
  
  func fetchData() {
    self.trips = [Trip]()
    db.collection("trips").getDocuments() { (querySnapshot, err) in
      if let err = err {
        print("Error getting documents: \(err)")
      } else {
        for document in querySnapshot!.documents {
          
          let data = document.data() as JSONDictionary
          
          if let coverImageID = data["coverImage"] as? String {
            self.fetchCoverPhoto(tripID: document.documentID, documentID: coverImageID){
              (coverResult) in
              self.fetchPhotoJournals(tripID: document.documentID) {
                (photoNum, journalNum) in
                self.fetchTravelPartnerPhoto(travelPartnerID: data["travelPartners"] as? [String] ?? []){
                  (images) in
                  if let trip = parseTripData(id: document.documentID, data: data, coverImage: coverResult, photoNum: photoNum, journalNum: journalNum, images: images) {
                    print("trips")
                    print(trip)
                    DispatchQueue.main.async {
                        self.trips.append(trip)
                    }
                  } else {
                    print("Error encountered parsing document \(document.documentID)")
                  }
                }
              }
            }
          }
        }
      }
    }
    //    db.collection("trips")
    //    .rx
    //    .getDocuments()
    //    .subscribe(onNext: { snap in
    //      for document in snap.documents {
    //          let data = document.data()
    //
    //          if let trip = self.parseTripData(data: data as JSONDictionary) {
    //            self.trips.append(trip)
    //            print(self.trips)
    //          } else{
    //            print("Error encountered parsing document \(document.documentID)")
    //          }
    //        }
    //    }, onError: { error in
    //        print("Error fetching snapshots: \(error)")
    //    }).disposed(by: disposeBag)
    
  }
  
  
  
  init(userID: String) {
    db = Firestore.firestore()
    self.userID = userID
  }
  
}
