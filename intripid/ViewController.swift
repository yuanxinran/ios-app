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
  
  var partnerID: String?
  var tripID: String?
  
  @IBOutlet weak var tripNum: UILabel!
  @IBOutlet weak var entryNum: UILabel!
  @IBOutlet weak var information: UILabel!

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let settings = FirestoreSettings()
    Firestore.firestore().settings = settings
    let database = FirbaseConnection()
    
    //adding a partner
    database.createPartner(lastName: "testLast", firstName: "testFirst", profilePicture: "profilePictures/user-1.png") {
      (result: String?) in
      self.partnerID = result
      let photoLocation = PhotoLocation(city: "San Francisco", state: "CA", country: "United States", latidude: 37.76007833333333, longitude: -122.50956666666667)
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy/MM/dd HH:mm"
      let photoDateTime = formatter.date(from: "2016/10/08 22:31")
      let photo = Photo(dateTime: photoDateTime! as NSDate, imagePath: "1.png", photoLocation: photoLocation)
      
      database.createTrip(title: "testTrip", travelPartners: [self.partnerID!], photos: [photo], startDate: photoDateTime! as NSDate, endDate: photoDateTime! as NSDate){
        (result: String?) in
        
        self.tripID = result
        database.getAllTrips {
          (result: [Trip]) in
          self.tripNum.text = "# of trips in the app: \(result.count)"
        }
      }
    }
    
    //adding a Trip
    
  }
  
  @IBAction func addPhotosAndJournalsToTrip(){
    if let tripID = self.tripID{
      
      let settings = FirestoreSettings()
      Firestore.firestore().settings = settings
      let database = FirbaseConnection()
      
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy/MM/dd HH:mm"
      let photoDateTime = formatter.date(from: "2016/10/08 22:31")
      let photoLocation = PhotoLocation(city: "San Francisco", state: "CA", country: "United States", latidude: 37.76007833333333, longitude: -122.50956666666667)
      
      let photo2 = Photo(dateTime: photoDateTime! as NSDate, imagePath: "2.png", photoLocation: photoLocation)
      let photo3 = Photo(dateTime: photoDateTime! as NSDate, imagePath: "3.png", photoLocation: photoLocation)
      let journal1 = Journal(dateTime: photoDateTime! as NSDate, title: "testJournal", content: "This is my first journal! ", backgroundPicture: "pic.png")
      database.addPhotosToTrip(tripID, [photo2,photo3])
      database.addJournalToTrip(tripID, journal1)
      
    }
  }
  
  
  
   @IBAction func getTripPhotos(){
    self.getDataAndUpdatePhotos()
  }
  
  @IBAction func getTripInformation(){
    if let tripID = self.tripID{
      let settings = FirestoreSettings()
      Firestore.firestore().settings = settings
      let database = FirbaseConnection()
      
      database.getTripByID(tripID: tripID){
        (result: Trip?) in
        
        self.entryNum.text = ""
        if let trip = result{
          self.information.text = "Title => \(trip.title), Date => \(trip.startDate) - \(trip.endDate)"
        }
        
      }
      
    }
  }
  
  
  @IBAction func getTripJournals(){
    self.getDataAndUpdateJournals()
  }
  
  @IBAction func getTripTravelPartners(){
    if let tripID = self.tripID{
      let settings = FirestoreSettings()
      Firestore.firestore().settings = settings
      let database = FirbaseConnection()
      
      database.getTripTravelPartners(tripID:tripID) {
        (result: [String]) in
        self.entryNum.text = "There are \(result.count) travel partners in the latest trip"
        var txt = ""
        for partnerID in result {
          database.getPartnerByID(partnerID: partnerID) {
            (partner: Person?) in
            if let partner = partner{
              txt = txt+"\(partner.firstName) \(partner.lastName) \n"
            }
          
            self.information.text = txt
          }
        }
        
        
      }
      
    }
  }
  
  func getDataAndUpdatePhotos(){
    if let tripID = self.tripID{
      let settings = FirestoreSettings()
      Firestore.firestore().settings = settings
      let database = FirbaseConnection()
      
      database.getTripPhotos(tripID:tripID) {
        (result: [Photo]) in
        self.entryNum.text = "There are \(result.count) photos in the latest trip"
        var txt = ""
        for photo in result {
          txt = txt+"Path => \(photo.imagePath), location => \(photo.photoLocation.city) \(photo.photoLocation.country), date => \(photo.dateTime)\n"
        }
        print("here is the txt", txt)
        self.information.text = txt
      }
      
    }
  }
  
  func getDataAndUpdateJournals(){
    if let tripID = self.tripID{
      let settings = FirestoreSettings()
      Firestore.firestore().settings = settings
      let database = FirbaseConnection()
      
      database.getTripJournals(tripID:tripID) {
        (result: [Journal]) in
        
        self.entryNum.text = "There are \(result.count) journals in the latest trip"
        
        var txt = ""
        for journal in result {
          txt = txt+"Title => \(journal.title ?? "No Title"), Content => \(journal.content)"+"\n"
        }
        self.information.text = txt
      }
      
    }
  }
    
    
    
  
        //adding additional photos and journals to the trip
  
  
      
  
      
      
    
    
    
    //adding photos to the trip
    
  
    
    
    
   
   
//    database.getAllTrips()
    // Do any additional setup after loading the view.


}

