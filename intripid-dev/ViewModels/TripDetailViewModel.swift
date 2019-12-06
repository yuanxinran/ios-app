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
    db.collection("trips").document(self.tripID).collection("photos").whereField("archived", isEqualTo: false).getDocuments(){ (querySnapshot, err) in
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
          if let data = document.data(), let partner = parseTravelPartnerData(id: document.documentID, data: data){
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
                var entries = [Entry]()
                let photoEntries = photos.map {Entry(journal: nil, photo: $0, type: "photo")}
                let journalEntries = journals.map{Entry(journal: $0, photo: nil, type:"journal")}
                entries = (photoEntries + journalEntries).sorted(by: <)
                let tripResult = parseTripDetailData(id: document.documentID, data: data, coverImage: coverPhoto, entries: entries, travelPartners: travelPartners)
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
