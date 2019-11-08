//
//  ModelTest.swift
//  
//
//  Created by Zoe Teoh  on 11/8/19.
//

import XCTest
import Firebase
import FirebaseFirestore
import SwiftUI
@testable import intripid

class ModelTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
  
  func testUserModel() {
    let testUser = User(id: "user_id", firstName: "fname", lastName: "lname", email: "email42", username: "user42name", profilePicture: "photo42")
    let testUserEquality = User(id: "user_id", firstName: "fname", lastName: "lname", email: "email42", username: "user42name", profilePicture: "differentphoto42")
    
    XCTAssertNotNil(testUser)
    XCTAssertEqual(testUser.id, "user_id")
    XCTAssertEqual(testUser.firstName, "fname")
    XCTAssertEqual(testUser.lastName, "lname")
    XCTAssertEqual(testUser.email, "email42")
    XCTAssertEqual(testUser.username, "user42name")
    XCTAssertEqual(testUser.profilePicture, "photo42")
    
    XCTAssertEqual(testUser, testUserEquality)
    
    let testUserSetting = UserSettings()
    
    XCTAssertNotNil(testUserSetting)
    XCTAssertEqual(testUserSetting.documentID, "mD6zAy0T0oh9qAYajiyE")
    XCTAssertEqual(testUserSetting.userID, "xinrany")
  }
  
  func testEntryModel(){
    let entryPhoto = Entry(journal: nil, photo: testPhoto, type: "photo")
    let entryPhoto2 = Entry(journal: nil, photo: testPhoto, type: "photo")
    let entryJournal  = Entry(journal: testJournal, photo: nil, type: "journal")
    let invalidEntry = Entry(journal: nil, photo: nil, type: "non")
    XCTAssertNotEqual(entryPhoto, nil)
    XCTAssertNotEqual(entryJournal, nil)
    XCTAssertEqual(entryPhoto.getDateTime(), photoDate)
    XCTAssertEqual(entryJournal.getDateTime(), journalDate)
    XCTAssertEqual(entryPhoto, entryPhoto2)
    
    XCTAssertEqual(entryPhoto.getDocID(), "photo_id")
    XCTAssertEqual(entryJournal.getDocID(), "journal_id")
    XCTAssertEqual(invalidEntry.getDocID(), "noid")
    
    let entries : [Entry] = [entryPhoto, entryJournal]
    let sortedEntries = entries.sorted(by: <)
    
    XCTAssertEqual(sortedEntries[0], entryPhoto)
    XCTAssertEqual(sortedEntries[1], entryJournal)
  
  }
  
  func testTripModel(){
    let tempEntryPhoto = Entry(journal: nil, photo: testPhoto, type: "photo")
    let tempTripLocation = TripLocation(city: "location_city", state: "location_state", country: "location_country", latitude: -42.0, longitude: 42.0)
    let tempTravelPartner = TravelPartner(id: "partner_id", firstName: "partner_fname", lastName: "partner_lname", profilePicture: "parter_picture")
    let testTripDetail = TripDetail(id: "detail_id", title: "detail_title", coverImage: nil, entries: [tempEntryPhoto], startDate: NSDate(), endDate: NSDate(), travelPartners: [tempTravelPartner], locations: [tempTripLocation])
//    let testTripDetailEquality = TripDetail(id: "detail_id", title: "detail_title", coverImage: nil, entries: [tempEntryPhoto], startDate: NSDate(), endDate: NSDate(), travelPartners: [tempTravelPartner], locations: [tempTripLocation])
    
    XCTAssertEqual(testTripDetail, testTripDetail)
    
    let testTripLocation = TripLocation(city: "location_city", state: "location_state", country: "location_country", latitude: -42.0, longitude: 42.0)
    let testTripLocationEquality = TripLocation(city: "location_city", state: "location_state", country: "location_country", latitude: -42.0, longitude: 42.0)
    
    XCTAssertEqual(testTripLocation, testTripLocationEquality)
    
    
    //photo time < journal time
    let testTripData2:JSONDictionary = ["startDate": journalTimestamp, "travelPartners": ["partner_1", "partner_2"], "coverImage": ["cover_image_1","cover_image_2"], "endDate": journalTimestamp, "title": "Trip Test 1"]
    
    let testTripData3:JSONDictionary = ["startDate": photoTimestamp, "travelPartners": ["partner_1", "partner_2"], "coverImage": ["cover_image_1","cover_image_2"], "endDate": journalTimestamp, "title": "Trip Test 1"]
    
    let trip1 : Trip? = parseTripData(id: "trip_id_42", data: testTripData, coverImage: testPhoto, photoNum: 42, journalNum: 1, images: ["image_1", "image_2", "image_3", "image_4"])
    let trip2 : Trip? = parseTripData(id: "trip_id_43", data: testTripData2, coverImage: testPhoto, photoNum: 42, journalNum: 1, images: ["image_1", "image_2", "image_3", "image_4"])
    let trip3 : Trip? = parseTripData(id: "trip_id_44", data: testTripData3, coverImage: testPhoto, photoNum: 42, journalNum: 1, images: ["image_1", "image_2", "image_3", "image_4"])
        
    let trips : [Trip] = [trip1!, trip2!, trip3!]
    let sortedTrips = Array(trips.sorted(by: < ).reversed())
    
    XCTAssertEqual(sortedTrips[0], trip2)
    XCTAssertEqual(sortedTrips[1], trip3)
    XCTAssertEqual(sortedTrips[2], trip1)
    
    let trip1_copy : Trip? = parseTripData(id: "trip_id_42", data: testTripData, coverImage: testPhoto, photoNum: 420, journalNum: 420, images: [])
    
    XCTAssertEqual(trip1, trip1_copy)
    XCTAssertNotEqual(trip1, trip2)
  }
  
  func testJournalModel() {
    let testJournal = Journal(id: "journal_id", dateTime: NSDate(), title: "journal_title", content: "journal_content", gradientStart: Color.red, gradientEnd: Color.yellow)
    
//    let testJournalEquality = Journal(id: "journal_id", dateTime: NSDate(), title: "journal_title", content: "journal_content", gradientStart: Color.red, gradientEnd: Color.yellow)
    
    XCTAssertNotNil(testJournal)
    XCTAssertEqual(testJournal.id, "journal_id")
    XCTAssertEqual(testJournal.title, "journal_title")
    XCTAssertEqual(testJournal.content, "journal_content")
    XCTAssertEqual(testJournal.gradientStart, Color.red)
    XCTAssertEqual(testJournal.gradientEnd, Color.yellow)
    
    XCTAssertEqual(testJournal, testJournal)
  }
  
  func testPhotoModel() {
    let testPhotoLocation = PhotoLocation(city: "photo_city", state: "photo_state", country: "photo_country", latitude: -42.0, longitude: 42)
    let testPhotoLocationEquality = PhotoLocation(city: "photo_city", state: "photo_state", country: "photo_country", latitude: -42.0, longitude: 42)
    
    XCTAssertNotNil(testPhotoLocation)
    XCTAssertEqual(testPhotoLocation.city, "photo_city")
    XCTAssertEqual(testPhotoLocation.state, "photo_state")
    XCTAssertEqual(testPhotoLocation.country, "photo_country")
    XCTAssertEqual(testPhotoLocation.latitude, -42.0)
    XCTAssertEqual(testPhotoLocation.longitude, 42)
    
    XCTAssertEqual(testPhotoLocation, testPhotoLocationEquality)
    
    let testPhoto = Photo(id: "photo_id", dateTime: NSDate(), imagePath: "photo_imagepath", photoLocation: testPhotoLocation)
    let testPhotoEquality = Photo(id: "photo_id", dateTime: NSDate(), imagePath: "photo_imagepath", photoLocation: testPhotoLocationEquality)
    
    XCTAssertNotNil(testPhoto)
    XCTAssertEqual(testPhoto.id, "photo_id")
    XCTAssertEqual(testPhoto.imagePath, "photo_imagepath")
    XCTAssertEqual(testPhoto.photoLocation, testPhotoLocation)
    
    XCTAssertEqual(testPhoto, testPhotoEquality)
  }
  
  func testTravelPartnerModel() {
    let testTravelPartner = TravelPartner(id: "partner_id", firstName: "partner_fname", lastName: "partner_lname", profilePicture: "parter_picture")
    let testTravelPartnerEquality = TravelPartner(id: "partner_id", firstName: "partner_fname", lastName: "partner_lname", profilePicture: "partner_picture")
    
    XCTAssertNotNil(testTravelPartner)
    XCTAssertEqual(testTravelPartner.id, "partner_id")
    XCTAssertEqual(testTravelPartner.firstName, "partner_fname")
    XCTAssertEqual(testTravelPartner.lastName, "partner_lname")
    XCTAssertEqual(testTravelPartner.profilePicture, "partner_picture")
    
    XCTAssertEqual(testTravelPartner, testTravelPartner)
  }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
