//
//  FirebaseConnection.swift
//  intripid
//
//  Created by Anna Yuan on 10/21/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import FirebaseFirestore

typealias JSONDictionary = [String: Any]

class FirbaseConnection {
  
  var ref: DocumentReference? = nil
  var db: Firestore!
  
  
  init(){
    db = Firestore.firestore()
  }
  
  //CREATE Creating a travel partner
  func createPartner(lastName: String, firstName: String, profilePicture: String?, completion: @escaping (_ result:String?) -> Void) {
    var ref: DocumentReference? = nil
    var docID: String? = nil
    ref = db.collection("people").addDocument(data: [
      "lastName": lastName,
      "firstName": firstName,
      "profilePicture": profilePicture ?? NSNull()
    ]) { err in
      if let err = err {
        print("Error adding document: \(err)")
      } else {
        print("Document added with ID: \(ref!.documentID)")
        docID = ref?.documentID
        completion(docID)
        
      }
    }
  }
  
  //UPDATE Update information for a travel partner
  func updateTrip(personID: String, lastName: String, firstName: String, profilePicture: String?, completion: @escaping (_ result:String?) -> Void){
    let tripRef = db.collection("people").document("personID")
    tripRef.updateData([
      "lastName": lastName,
      "firstName": firstName,
      "profilePicture": profilePicture ?? NSNull()
    ]) { err in
      if let err = err {
        print("Error encountered when updating the trip information \(err)")
      } else {
        print("Successfully updated the trip information")
        completion(personID)
      }
    }
    
  }
  
  //CREATE Creating a trip
  func createTrip(title: String, travelPartners: [String], photos: [Photo],startDate: NSDate, endDate: NSDate, completion: @escaping (_ result:String?) -> Void){
    var ref: DocumentReference? = nil
    var docID: String? = nil
    //TODO: ADD PHOTOS TO THE CLOUD STORAGE
    ref = db.collection("trips").addDocument(data: [
      "title": title,
      "travelPartners": travelPartners,
      "startDate": startDate,
      "endDate": endDate
    ]) { err in
      if let err = err {
        print("Error adding document: \(err)")
      } else {
        print("Trip added with ID: \(ref!.documentID)")
        if photos.count > 0{
          self.addPhotosToTrip(ref!.documentID, photos)
        }
        docID = ref?.documentID
        completion(docID)
      }
    }

  }
  
  //UPDATE Update basic information for a trip
  func updateTrip(tripID: String, title: String, travelPartners: [String],completion: @escaping (_ result:String?) -> Void){
    let tripRef = db.collection("trips").document("tripID")
    tripRef.updateData([
      "title": title,
      "travelPartners": travelPartners,
    ]) { err in
      if let err = err {
        print("Error encountered when updating the trip information \(err)")
      } else {
        print("Successfully updated the trip information")
        completion(tripID)
      }
    }
    
  }
  
  
  //UPDATE Adding photos to the trip
  //TODO: Update the startDate and endDate based on the photo startDate and endDate
  func addPhotosToTrip(_ tripID: String, _ photos: [Photo]) -> Void{
    let tripRef = db.collection("trips").document(tripID)
    
    for photo in photos {
      tripRef.collection("photos").addDocument(data: [
        "dateTime": photo.dateTime,
        "imagePath": photo.imagePath,
        "photoLocation":[
          "city": photo.photoLocation.city,
          "state": photo.photoLocation.state,
          "country": photo.photoLocation.country,
          "geocoding": GeoPoint(latitude: photo.photoLocation.latidude, longitude: photo.photoLocation.longitude)
        ]
      ]){ err in
        if let err = err {
          print("Error writing document: \(err)")
        } else {
          print("Successfully added photos to the trip")
        }
      }
    }
    

  }
  
  
  
  //UPDATE Adding a journal to the trip
  func addJournalToTrip(_ tripID: String, _ journal: Journal) -> Void{
    let tripRef = db.collection("trips").document(tripID)
    
    tripRef.collection("journals").addDocument(data: [
      "dateTime": journal.dateTime,
      "title": journal.title ?? NSNull(),
      "backgroundPicture": journal.backgroundPicture ?? NSNull(),
      "content": journal.content
    ]){ err in
      if let err = err {
        print("Error writing document: \(err)")
      } else {
        print("Document successfully written!")
      }
    }
  }
  
  
  //READ Get all trips in the app
  func getAllTrips(completion: @escaping (_ result:[Trip]) -> Void) {
    var trips = [Trip]()
    
    db.collection("trips").getDocuments() { (querySnapshot, err) in
      if let err = err {
        print("Error getting documents: \(err)")
      } else {
        for document in querySnapshot!.documents {
          
          let data = document.data()
          if let trip = self.parseTripData(data: data as JSONDictionary) {
            trips.append(trip)
          } else{
            print("Error encountered parsing document \(document.documentID)")
          }
          
        }
      }
      completion(trips);
    }
  }
  
  //READ Get a trip by tripID
  func getTripByID(tripID: String, completion: @escaping (_ result: Trip?) -> Void) {
    var result : Trip?
    let tripRef = db.collection("trips").document(tripID)
    tripRef.getDocument { (document, error) in
      if let document = document, document.exists {
        if let data = document.data(), let trip = self.parseTripData(data: data){
          result = trip
        }
      } else {
        print("Document does not exist")
      }
      completion(result)
    }
  }
  
  //READ  Get all photos in a trip
  func getTripPhotos(tripID: String, completion: @escaping (_ result:[Photo]) -> Void) {
    let tripRef = db.collection("trips").document(tripID)
    var photos = [Photo]()
    var count = 0
    
    tripRef.collection("photos").getDocuments() { (querySnapshot, err) in
      if let err = err {
        print("Error getting documents: \(err)")
      } else {
        for document in querySnapshot!.documents {
          count = count+1
          
          let data = document.data()
          if let photo = self.parsePhotoData(data: data as JSONDictionary) {
            photos.append(photo)
          } else{
            print("Error encountered parsing document \(document.documentID)")
          }
          
        }
      }
      completion(photos);
    }
  }
  
  
  
  //READ  Get all journals in a trip
  func getTripJournals(tripID: String, completion: @escaping (_ result: [Journal]) -> Void) {
    let tripRef = db.collection("trips").document(tripID)
    var journals = [Journal]()
    var count = 0
    
    tripRef.collection("journals").getDocuments() { (querySnapshot, err) in
      if let err = err {
        print("Error getting documents: \(err)")
      } else {
        for document in querySnapshot!.documents {
          count = count+1
          let data = document.data()
          if let journal = self.parseJournalData(data: data as JSONDictionary){
            journals.append(journal)
          } else {
            print("Error parsing journal data \(document.documentID)")
          }
          
        }
      }
      completion(journals);
    }
    
    
  }
  
  //READ  Get all travel partners in a trip
  func getTripTravelPartners(tripID: String, completion: @escaping (_ result: [String]) -> Void) {
    let tripRef = db.collection("trips").document(tripID)
    var partnerIDs = [String]()
    
    tripRef.getDocument { (document, error) in
      if let document = document, document.exists {
        let data = document.data()
        if let data = data {
          partnerIDs = data["travelPartners"] as! [String]
          print("travel partners here: ", partnerIDs)
        }
      } else {
        print("Document does not exist")
      }
      completion(partnerIDs)
    }
    
  }
  
  //READ Get information for a travel partner
  func getPartnerByID(partnerID: String, completion: @escaping (_ result: Person?) -> Void) {
    var partner : Person?
    let partnerRef = db.collection("people").document(partnerID)
    partnerRef.getDocument { (document, error) in
      if let document = document, document.exists {
        let data = document.data()
        if let data = data, let lastName = data["lastName"] as? String, let firstName=data["firstName"] as? String {
          partner = Person(lastName: lastName, firstName: firstName, profilePicture: data["profilePicture"] as? String)
        }
      } else {
        print("Document does not exist")
      }
       completion(partner)
    }
    
    
    
  }
  
  
  
  func parsePhotoData(data: JSONDictionary) -> Photo? {
    if let locationData = data["photoLocation"] as? [String:AnyObject], let geopoint = locationData["geocoding"] as? GeoPoint, let dateTime = data["dateTime"] as? Timestamp, let imagePath = data["imagePath"] as? String {
      
      if let city = locationData["city"] as? String, let state = locationData["state"] as? String, let country = locationData["country"] as? String {
        
        let photoLocation = PhotoLocation(city: city, state: state, country: country, latidude: geopoint.latitude, longitude: geopoint.longitude)
        return Photo(dateTime: dateTime.dateValue() as NSDate, imagePath: imagePath, photoLocation: photoLocation)
        
      }
    }
    return nil
  }
  
  func parseJournalData(data: JSONDictionary) -> Journal? {
    if let dateTime = data["dateTime"] as? Timestamp, let content = data["content"] as? String{
      let journal =  Journal(dateTime: dateTime.dateValue() as NSDate, title: data["title"] as? String, content: content, backgroundPicture: data["background"] as? String)
      return journal
    }
    return nil
  }
  
  
  func parseTripData(data: JSONDictionary) -> Trip? {
    if let startDate = data["startDate"] as? Timestamp,let endDate = data["endDate"] as? Timestamp, let title = data["title"] as? String {
      let trip =  Trip(title: title, travelPartners: nil, journals: nil, photos: nil, startDate: startDate.dateValue() as NSDate, endDate: endDate.dateValue() as NSDate)
      return trip
    }
    return nil
  }
  

}
