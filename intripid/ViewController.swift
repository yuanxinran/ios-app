//
//  ViewController.swift
//  intripid
//
//  Created by Zoe Teoh  on 10/20/19.
//  Copyright © 2019 zona. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class ViewController: UIViewController {
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let settings = FirestoreSettings()
    Firestore.firestore().settings = settings
    let database = FirbaseConnection()
    
    //adding a partner
    let partnerID = database.createPartner(lastName: "last", firstName: "first", profilePicture: "profilePictures/user-1.png")
    if let partnerID = partnerID{
      print("added partnerID \(partnerID)")
    }
    
    
    //adding a Trip
    let photoLocation = PhotoLocation(city: "San Francisco", state: "CA", country: "United States", latidude: 37.76007833333333, longitude: -122.50956666666667)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    let photoDateTime = formatter.date(from: "2016/10/08 22:31")
    let photo = Photo(dateTime: photoDateTime! as NSDate, imagePath: "1.png", photoLocation: photoLocation)
    
     let tripID = database.createTrip(title: "testTrip", travelPartners: [partnerID!], photos: [photo])
     if let tripID = tripID {
        print("successfully added a new trip \(tripID)")
        //adding additional photos and journals to the trip
        let photo2 = Photo(dateTime: photoDateTime! as NSDate, imagePath: "2.png", photoLocation: photoLocation)
        let photo3 = Photo(dateTime: photoDateTime! as NSDate, imagePath: "3.png", photoLocation: photoLocation)
        let journal1 = Journal(dateTime: photoDateTime! as NSDate, title: "testJournal", content: "This is my first journal! ", backgroundPicture: "pic.png")
        database.addPhotosToTrip(tripID, [photo2,photo3])
        database.addJournalToTrip(tripID, journal1)
        database.getTripPhotos(tripID:tripID) {
          (result: [Photo]) in
          print("This trip has \(result.count) photos")
        }
      
        database.getTripJournals(tripID:tripID) {
          (result: [Journal]) in
          
            print("There are \(result.count) journals in this trip")
            for journal in result{
              print(journal.content)
            }
        }
      
        database.getTripTravelPartners(tripID:tripID) {
          (result: [String]) in
          print("This trip has \(result.count) partners")
        }
      
      
    
     }
    
    //adding photos to the trip
    
  
    
    
    
   
   
//    database.getAllTrips()
    // Do any additional setup after loading the view.
  }


}

