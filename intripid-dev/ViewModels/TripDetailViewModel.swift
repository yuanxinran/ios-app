//
//  TripDetailViewModel.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/6/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore


class TripDetailViewModel: ObservableObject {
  @Published var trip  = [TripDetail]()
  var tripID: String
  var db: Firestore!
  
  init(tripID: String){
    self.tripID = tripID
    db = Firestore.firestore()
  }

  
  
  func parseTripDetailData(id: String, data: JSONDictionary, coverImage: Photo?, photos: [Photo], journals: [Journal], travelPartners: [TravelPartner]) -> TripDetail? {
    
    if let title = data["title"] as? String, let startDate = data["startDate"] as? Timestamp, let endDate = data["endDate"] as? Timestamp {
      
      var tripLocation : TripLocation
      if let coverImage = coverImage, let imgLoc = coverImage.photoLocation{
        tripLocation = TripLocation(city: imgLoc.city, state: imgLoc.state, country: imgLoc.country, latitude: imgLoc.latitude, longitude: imgLoc.longitude)
      } else {
         tripLocation = TripLocation(city: "Pittsburgh", state: "PA", country: "United States", latitude: 40.44062, longitude: -79.99589)
      }
      
      let trip = TripDetail(id: id, title: title, coverImage: coverImage, photos: photos, journals: journals, startDate: startDate.dateValue() as NSDate, endDate: endDate.dateValue() as NSDate, travelPartners: travelPartners, locations: [tripLocation])
      
       return trip
     }
    return nil
  }
  
  
  //fetch the cover photo for the trip
  func fetchCoverPhoto(documentID: String, completion: @escaping (Photo?) -> ()){
    var result : Photo?
    let photoRef = db.collection("trips").document(self.tripID).collection("photos").document(documentID)
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
  
  func fetchPhotos(completion: @escaping ([Photo]) -> ()){
    var result  = [Photo]()
    db.collection("trips").document(self.tripID).collection("photos").getDocuments(){ (querySnapshot, err) in
      for document in querySnapshot!.documents {
        let data = document.data() as JSONDictionary
        if let photo = parsePhotoData(id: document.documentID, data: data){
          result.append(photo)
        }
      }
      completion(result)
    }
  }
  
  func fetchJournals(completion: @escaping ([Journal]) -> ()){
    var result  = [Journal]()
    db.collection("trips").document(self.tripID).collection("journals").getDocuments(){ (querySnapshot, err) in
      for document in querySnapshot!.documents {
        let data = document.data() as JSONDictionary
        if let journal =  parseJournalData(id: document.documentID, data: data){
          result.append(journal)
        }
      }
      completion(result)
    }
  }
  
  
  //Fetching all the travel partners for the trip
  func fetchTravelPartners(travelPartnerID: [String], completion: @escaping ([TravelPartner]) -> ()){
    var result = [TravelPartner]()
    let dispatchGroup = DispatchGroup()
    let partnerCollection = db.collection("users").document(currentUserDoc).collection("travelPartners")
    for id in travelPartnerID {
      dispatchGroup.enter()
      let ref = partnerCollection.document(id)
      ref.getDocument { (document, error) in
        if let document = document, document.exists {
          if let data = document.data(), let imageURL = data["profilePicture"] as? String, let firstName = data["firstName"] as? String, let lastName = data["lastName"] as? String {
            let partner = TravelPartner(id: document.documentID, firstName: firstName, lastName: lastName, profilePicture: imageURL)
            result.append(partner)
          }
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
    let tripRef = db.collection("trips").document(tripID)
    tripRef.getDocument { (document, error) in
      if let document = document, document.exists {
        let data = document.data() as! JSONDictionary
        self.fetchPhotos {
          (photos) in
          self.fetchJournals {
            (journals) in
            self.fetchTravelPartners(travelPartnerID: data["travelPartners"] as? [String] ?? []){
              (travelPartners) in
              self.fetchCoverPhoto(documentID: data["coverImage"] as! String) {
                (coverPhoto) in
                let tripResult = self.parseTripDetailData(id: document.documentID, data: data, coverImage: coverPhoto, photos: photos, journals: journals, travelPartners: travelPartners)
                if let tripResult = tripResult{
                  self.trip = [tripResult]
                }
              }
            }
          }
        }
      } else {
        print("Document does not exist")
      }
    }
    
    
  }
  
  
  
}
