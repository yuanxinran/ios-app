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


class TripViewModel: ObservableObject {
  @Published var trips = [Trip]()
  @Published var numbers = ""
  var userID :  String
  var db: Firestore!
  
  
  func fetchCoverPhoto(tripID: String ,documentID: String, completion: @escaping (Photo?) -> ()){
    var result : Photo?
    let photoRef = db.collection("trips").document(tripID).collection("photos").document(documentID)
    photoRef.getDocument { (document, error) in
      if let document = document, document.exists {
        if let data = document.data(), let photo = parsePhotoData(id: documentID, data:data) {
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
    tripRef.collection("photos").whereField("archived", isEqualTo: false).getDocuments(){ (querySnapshot, err) in
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
            result.append(imageURL)
          }
        } else {
          result.append("")
        }
        dispatchGroup.leave()
      }
    }
    dispatchGroup.notify(queue: DispatchQueue.global()) {
      completion(result)
    }
  }
  
  
  func refreshDataForTrip(tripID: String){
    for j in 0..<self.trips.count{
      if self.trips[j].id == tripID {
        db.collection("trips").document(tripID).getDocument { (document, error) in
          if let document = document, document.exists {
            let data = document.data() as! JSONDictionary
            if let coverImageID = data["coverImage"] as? String {
              self.fetchCoverPhoto(tripID: tripID, documentID: coverImageID){
                (coverResult) in
                self.fetchPhotoJournals(tripID: tripID) {
                  (photoNum, journalNum) in
                  self.fetchTravelPartnerPhoto(travelPartnerID: data["travelPartners"] as? [String] ?? []){
                    (images) in
                    if let trip = parseTripData(id: tripID, data: data, coverImage: coverResult, photoNum: photoNum, journalNum: journalNum, images: images) {
                      DispatchQueue.main.async {
                        self.trips[j] = trip
                        self.trips = self.trips.sorted(by: > )
                      }
                    } else {
                      print("Error encountered parsing document \(document.documentID)")
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
  }
  
  func fetchData() {
    self.trips = [Trip]()
    db.collection("trips").whereField("archived", isEqualTo: false).getDocuments() { (querySnapshot, err) in
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
                    DispatchQueue.main.async {
                      self.trips.append(trip)
                      self.trips = self.trips.sorted(by: > )
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
  }
  //    db.collection("trips").addSnapshotListener {(snap, error) in
  //
  //      for i in snap!.documentChanges{
  //        let document = i.document
  //        if i.type == .added {
  //
  //          let data = document.data() as JSONDictionary
  //
  //          if let coverImageID = data["coverImage"] as? String {
  //            self.fetchCoverPhoto(tripID: document.documentID, documentID: coverImageID){
  //              (coverResult) in
  //              self.fetchPhotoJournals(tripID: document.documentID) {
  //                (photoNum, journalNum) in
  //                self.fetchTravelPartnerPhoto(travelPartnerID: data["travelPartners"] as? [String] ?? []){
  //                  (images) in
  //                  if let trip = parseTripData(id: document.documentID, data: data, coverImage: coverResult, images: images) {
  //                    DispatchQueue.main.async {
  ////                        self.numbers = "photos: \(data["photoNum"])"
  //                        self.trips.append(trip)
  //                    }
  //                  } else {
  //                    print("Error encountered parsing document \(document.documentID)")
  //                  }
  //                }
  //              }
  //            }
  //          }
  //
  //        }
  //
  //        if i.type == .modified{
  //          print("I am pissed off")
  //          for j in 0..<self.trips.count{
  //            if self.trips[j].id == i.document.documentID {
  //              let data = document.data() as JSONDictionary
  //              if let coverImageID = data["coverImage"] as? String {
  //                self.fetchCoverPhoto(tripID: document.documentID, documentID: coverImageID){
  //                  (coverResult) in
  //                    self.fetchTravelPartnerPhoto(travelPartnerID: data["travelPartners"] as? [String] ?? []){
  //                      (images) in
  //                      if let trip = parseTripData(id: document.documentID, data: data, coverImage: coverResult, images: images) {
  //                        DispatchQueue.main.async {
  ////                          self.numbers = "last change: \(NSDate())"
  //                            self.trips[j] = trip
  //                          print(self.trips)
  //                        }
  //                      } else {
  //                        print("Error encountered parsing document \(document.documentID)")
  //                      }
  //                  }
  //                }
  //              }
  //
  //            }
  //          }
  //        }
  //      }
  //    }
  //
  
  //
  //    db.collection("trips").getDocuments() { (querySnapshot, err) in
  //      if let err = err {
  //        print("Error getting documents: \(err)")
  //      } else {
  //        for document in querySnapshot!.documents {
  //
  //          let data = document.data() as JSONDictionary
  //
  //          if let coverImageID = data["coverImage"] as? String {
  //            self.fetchCoverPhoto(tripID: document.documentID, documentID: coverImageID){
  //              (coverResult) in
  //              self.fetchPhotoJournals(tripID: document.documentID) {
  //                (photoNum, journalNum) in
  //                self.fetchTravelPartnerPhoto(travelPartnerID: data["travelPartners"] as? [String] ?? []){
  //                  (images) in
  //                  if let trip = parseTripData(id: document.documentID, data: data, coverImage: coverResult, photoNum: photoNum, journalNum: journalNum, images: images) {
  //                    print("trips")
  //                    print(trip)
  //                    DispatchQueue.main.async {
  //                        self.trips.append(trip)
  //                    }
  //                  } else {
  //                    print("Error encountered parsing document \(document.documentID)")
  //                  }
  //                }
  //              }
  //            }
  //          }
  //        }
  //      }
  //    }
  
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
  
  
  
  
  
  init(userID: String) {
    db = Firestore.firestore()
    self.userID = userID
    
  }
  
}
