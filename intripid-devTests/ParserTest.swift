//
//  TripViewModelTest.swift
//  intripid-devTests
//
//  Created by Zoe Teoh  on 11/6/19.
//  Copyright © 2019 zona. All rights reserved.
//

import XCTest
import Firebase
import FirebaseFirestore
import SwiftUI
@testable import intripid

let photoDate = Date(timeIntervalSinceReferenceDate: 123456789.0) as NSDate
let journalDate = Date(timeIntervalSinceReferenceDate: 123456900.0) as NSDate
let photoTimestamp = Timestamp(date: photoDate as Date)
let journalTimestamp = Timestamp(date: journalDate as Date)
let testPhotoLocation: PhotoLocation = PhotoLocation(city: "Pittsburgh", state: "PA", country: "USA", latitude: -42.042, longitude: 42.042)
let testPhoto: Photo = Photo(id:"photo_id", dateTime: photoDate, imagePath: "image_path_1", photoLocation: testPhotoLocation)
let testJournal : Journal = Journal(id: "journal_id", dateTime: journalDate, title: "title", content: "content", gradientStart: Color("red"), gradientEnd: Color("green"))

let testTripData:JSONDictionary = ["startDate": photoTimestamp, "travelPartners": ["partner_1", "partner_2"], "coverImage": ["cover_image_1","cover_image_2"], "endDate": photoTimestamp, "title": "Trip Test 1"]
let testTripData_invalidDate:JSONDictionary = ["startDate": photoDate, "travelPartners": ["partner_1", "partner_2"], "coverImage": ["cover_image_1","cover_image_2"], "endDate":photoDate, "title": "Trip Test 1"]
let testTripData_invalidTravelPartners_1:JSONDictionary = ["startDate": Timestamp(), "travelPartners": "invalid_partner", "coverImage": ["cover_image_1","cover_image_2"], "endDate":Timestamp(), "title": "Trip Test 1"]
let testTripData_invalidTravelPartners_2:JSONDictionary = ["startDate": Timestamp(), "travelPartners": [999, 991, 995], "coverImage": ["cover_image_1","cover_image_2"], "endDate":Timestamp(), "title": "Trip Test 1"]
let testTripData_invalidTitle_1:JSONDictionary = ["startDate": Timestamp(), "travelPartners": ["partner_1", "partner_2"], "coverImage": ["cover_image_1","cover_image_2"], "endDate":Timestamp(), "title": ["Trip Test 1"]]
let testTripData_invalidTitle_2:JSONDictionary = ["startDate": Timestamp(), "travelPartners": ["partner_1", "partner_2"], "coverImage": ["cover_image_1","cover_image_2"], "endDate":Timestamp(), "title": 999]

let testPhotoData:JSONDictionary = ["photoLocation": ["geocoding": GeoPoint(latitude: -42.024, longitude: 42.024), "city": "test_city", "country": "test_country"], "dateTime": photoTimestamp, "imagePath": "image_path_1"]
let testPhotoNoLocationData:JSONDictionary = ["dateTime": photoTimestamp, "imagePath": "image_path_1"]
let testPhotoData_invalid1:JSONDictionary = ["imagePath": "image_path_1"]
let testPhotoData_invalid2:JSONDictionary = ["dateTime": photoTimestamp]

let testData:JSONDictionary = ["photoLocation": ["geocoding": GeoPoint(latitude: -42.024, longitude: 42.024), "city": "test_city", "country": "test_country"], "dateTime": Timestamp(), "imagePath": "image_path_1"]

let testJournalData: JSONDictionary = [ "dateTime": photoTimestamp, "title": "testJournal", "content":"testJournal", "startColor":"red", "endColor":"green"]
let testJournalData_invalidTitle: JSONDictionary = ["dateTime": photoTimestamp,  "content":"testJournal", "startColor":"red", "endColor":"green"]
let testJournalData_invalidColor1: JSONDictionary = ["dateTime": photoTimestamp, "title": "testJournal",  "content":"testJournal",  "endColor":"green"]
let testJournalData_invalidColor2: JSONDictionary = ["dateTime": photoTimestamp, "title": "testJournal",  "content":"testJournal",  "startColor":"green"]
let testJournalData_invalidContent: JSONDictionary = ["dateTime": photoTimestamp, "title": "testJournal",   "startColor":"green",  "endColor":"green"]
let testJournalData_invalidDateTime: JSONDictionary = [ "title": "testJournal", "content":"testJournal",  "startColor":"green",  "endColor":"green"]

let testTripDetailData : JSONDictionary = ["title": "title", "startDate": Timestamp(date: photoDate as Date), "endDate": Timestamp(date: photoDate as Date)]

let testTripDetailData_invalidTitle : JSONDictionary = ["startDate": Timestamp(date: photoDate as Date), "endDate": Timestamp(date: photoDate as Date)]
let testTripDetailData_invalidDate1 : JSONDictionary = ["title": "title", "startDate": "start", "endDate": Timestamp(date: photoDate as Date)]
let testTripDetailData_invalidDate2 : JSONDictionary = ["title": "title", "startDate": Timestamp(date: photoDate as Date), "endDate": "end"]


let testTravelPartnerData : JSONDictionary = ["firstName":"first", "lastName":"last", "profilePicture":"profile" ]
let testTravelPartnerData_invalidName1 : JSONDictionary = ["lastName":"last", "profilePicture":"profile" ]
let testTravelPartnerData_invalidName2 : JSONDictionary = ["firstName":"first", "profilePicture":"profile" ]
let testTravelPartnerData_noprofile : JSONDictionary = ["firstName":"first", "lastName":"last" ]

class ParserTest: XCTestCase {

  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testParseTripData_valid() {
    let testTrip:Trip? = parseTripData(id: "trip_id_42", data: testTripData, coverImage: testPhoto, photoNum: 42, journalNum: 420, images: ["image_1", "image_2", "image_3", "image_4"])
    XCTAssertNotEqual(testTrip, nil)
    XCTAssertEqual(testTrip!.id, "trip_id_42")
    XCTAssertEqual(testTrip!.title, "Trip Test 1")
    XCTAssertEqual(testTrip!.photoNum, 42)
    XCTAssertEqual(testTrip!.journalNum, 420)
    XCTAssertEqual(testTrip!.travelPartnerImages, ["image_1", "image_2", "image_3", "image_4"])
    XCTAssertEqual(testTrip!.travelPartners, ["partner_1", "partner_2"])
    XCTAssertEqual(testTrip!.latitude, -42.042)
    XCTAssertEqual(testTrip!.longitude, 42.042)
  }
  
  func testParseTripData_invalidDate() {
    let testTrip:Trip? = parseTripData(id: "trip_id_42", data: testTripData_invalidDate, coverImage: testPhoto, photoNum: 42, journalNum: 420, images: ["image_1", "image_2", "image_3", "image_4"])
    XCTAssertEqual(testTrip, nil)
  }
  
  func testParseTripData_invalidTravelPartners() {
    let testTrip_1:Trip? = parseTripData(id: "trip_id_42", data: testTripData_invalidTravelPartners_1, coverImage: testPhoto, photoNum: 42, journalNum: 420, images: ["image_1", "image_2", "image_3", "image_4"])
    XCTAssertEqual(testTrip_1, nil)
    let testTrip_2:Trip? = parseTripData(id: "trip_id_42", data: testTripData_invalidTravelPartners_2, coverImage: testPhoto, photoNum: 42, journalNum: 420, images: ["image_1", "image_2", "image_3", "image_4"])
    XCTAssertEqual(testTrip_2, nil)
  }
  
  func testParseTripData_invalidTitle() {
    let testTrip_1:Trip? = parseTripData(id: "trip_id_42", data: testTripData_invalidTitle_1, coverImage: testPhoto, photoNum: 42, journalNum: 420, images: ["image_1", "image_2", "image_3", "image_4"])
    XCTAssertEqual(testTrip_1, nil)
    let testTrip_2:Trip? = parseTripData(id: "trip_id_42", data: testTripData_invalidTitle_2, coverImage: testPhoto, photoNum: 42, journalNum: 420, images: ["image_1", "image_2", "image_3", "image_4"])
    XCTAssertEqual(testTrip_2, nil)
  }
  
  func testParsePhotoData_valid() {
    let testPhoto:Photo? = parsePhotoData(id: "photo_id_42", data: testPhotoData)
    XCTAssertNotEqual(testPhoto, nil)
    XCTAssertEqual(testPhoto!.imagePath, "image_path_1")
    XCTAssertNotEqual(testPhoto!.photoLocation, nil)
    XCTAssertEqual(testPhoto!.photoLocation!.city, "test_city")
    XCTAssertEqual(testPhoto!.photoLocation!.country, "test_country")
    XCTAssertEqual(testPhoto!.photoLocation!.latitude, -42.024)
    XCTAssertEqual(testPhoto!.photoLocation!.longitude, 42.024)
    XCTAssertEqual(testPhoto!.dateTime, photoDate)
  }
  
  func testParsePhotoData_nolocation(){
    let testPhoto:Photo? = parsePhotoData(id: "photo_id_42", data: testPhotoNoLocationData)
    XCTAssertNotEqual(testPhoto, nil)
    XCTAssertEqual(testPhoto!.imagePath, "image_path_1")
    XCTAssertEqual(testPhoto!.photoLocation, nil)
    XCTAssertEqual(testPhoto!.id, "photo_id_42")
    XCTAssertEqual(testPhoto!.dateTime, photoDate)
  }
  
  func testParsePhotoData_invalid(){
    let testPhoto:Photo? = parsePhotoData(id: "photo_id_42", data: testPhotoData_invalid1)
    XCTAssertEqual(testPhoto, nil)
    
    let testPhoto2:Photo? = parsePhotoData(id: "photo_id_42", data: testPhotoData_invalid2)
    XCTAssertEqual(testPhoto2, nil)
    
  }
  
  func testParseJournalData(){
    let testJournal:Journal? = parseJournalData(id: "journal_id_42", data: testJournalData)
    XCTAssertNotEqual(testJournal, nil)
    XCTAssertEqual(testJournal!.title, "testJournal")
    XCTAssertEqual(testJournal!.content, "testJournal")
    XCTAssertEqual(testJournal!.gradientStart, Color("red"))
    XCTAssertEqual(testJournal!.gradientEnd, Color("green"))
    
  }
  
  func testParseJournalData_Invalid(){
    let testJournal1:Journal? = parseJournalData(id: "journal_id_42", data: testJournalData_invalidTitle)
    let testJournal2:Journal? = parseJournalData(id: "journal_id_42", data: testJournalData_invalidColor1)
    let testJournal3:Journal? = parseJournalData(id: "journal_id_42", data: testJournalData_invalidColor2)
    let testJournal4:Journal? = parseJournalData(id: "journal_id_42", data: testJournalData_invalidContent)
    let testJournal5:Journal? = parseJournalData(id: "journal_id_42", data: testJournalData_invalidDateTime)
    XCTAssertEqual(testJournal1, nil)
    XCTAssertEqual(testJournal2, nil)
    XCTAssertEqual(testJournal3, nil)
    XCTAssertEqual(testJournal4, nil)
    XCTAssertEqual(testJournal5, nil)
  }
  
  
  func testParseTripDetailData_valid(){
    let testTrip:TripDetail? = parseTripDetailData(id: "trip_id_42", data: testTripDetailData, coverImage: testPhoto, entries:[], travelPartners: [])
    XCTAssertNotEqual(testTrip, nil)
    XCTAssertEqual(testTrip!.id, "trip_id_42")
    XCTAssertEqual(testTrip!.startDate, photoDate)
    XCTAssertEqual(testTrip!.endDate, photoDate)
    XCTAssertEqual(testTrip!.locations[0].city, "Pittsburgh")
    XCTAssertEqual(testTrip!.locations[0].state, "PA")
    XCTAssertEqual(testTrip!.locations[0].country, "USA")
    XCTAssertEqual(testTrip!.locations[0].latitude, -42.042)
    XCTAssertEqual(testTrip!.locations[0].longitude, 42.042)

  }
  
  func testParseTripDetailData_invalid(){
    let testTrip1:TripDetail? = parseTripDetailData(id: "trip_id_42", data: testTripDetailData_invalidTitle, coverImage: testPhoto, entries:[], travelPartners: [])
    let testTrip2:TripDetail? = parseTripDetailData(id: "trip_id_42", data: testTripDetailData_invalidDate1, coverImage: testPhoto, entries:[], travelPartners: [])
    let testTrip3:TripDetail? = parseTripDetailData(id: "trip_id_42", data: testTripDetailData_invalidDate2, coverImage: testPhoto, entries:[], travelPartners: [])
    
    
    XCTAssertEqual(testTrip1, nil)
    XCTAssertEqual(testTrip2, nil)
    XCTAssertEqual(testTrip3, nil)

  }
  
  func testParseTripDetailData_nolocation(){
    let coverImage:Photo? = parsePhotoData(id: "photo_id_42", data: testPhotoNoLocationData)
    let testTrip:TripDetail? = parseTripDetailData(id: "trip_id_42", data: testTripDetailData, coverImage: coverImage, entries:[], travelPartners: [])
    
    let testTripNoCover:TripDetail? = parseTripDetailData(id: "trip_id_42", data: testTripDetailData, coverImage: nil, entries:[], travelPartners: [])
    //Should have the location information for the default location
    XCTAssertNotEqual(testTrip, nil)
    XCTAssertEqual(testTrip!.id, "trip_id_42")
    XCTAssertEqual(testTrip!.startDate, photoDate)
    XCTAssertEqual(testTrip!.endDate, photoDate)
    XCTAssertEqual(testTrip!.locations[0].city, "Pittsburgh")
    XCTAssertEqual(testTrip!.locations[0].state, "PA")
    XCTAssertEqual(testTrip!.locations[0].country, "United States")
    XCTAssertEqual(testTrip!.locations[0].latitude, 40.44062)
    XCTAssertEqual(testTrip!.locations[0].longitude, -79.99589)
    
    XCTAssertNotEqual(testTripNoCover, nil)
    XCTAssertEqual(testTripNoCover!.id, "trip_id_42")
    XCTAssertEqual(testTripNoCover!.startDate, photoDate)
    XCTAssertEqual(testTripNoCover!.endDate, photoDate)
    XCTAssertEqual(testTripNoCover!.locations[0].city, "Pittsburgh")
    XCTAssertEqual(testTripNoCover!.locations[0].state, "PA")
    XCTAssertEqual(testTripNoCover!.locations[0].country, "United States")
    XCTAssertEqual(testTripNoCover!.locations[0].latitude, 40.44062)
    XCTAssertEqual(testTripNoCover!.locations[0].longitude, -79.99589)

  }
  
  
  func testParseTravelPartnerlData_valid(){
    let testTravelPartner: TravelPartner? = parseTravelPartnerData(id:"partner_id_42", data: testTravelPartnerData)
    let testTravelPartnerNoProfile: TravelPartner? = parseTravelPartnerData(id: "partner_id_42", data: testTravelPartnerData_noprofile)
    XCTAssertNotEqual(testTravelPartner, nil)
    XCTAssertNotEqual(testTravelPartnerNoProfile, nil)
    XCTAssertEqual(testTravelPartner!.lastName, "last")
    XCTAssertEqual(testTravelPartner!.firstName, "first")
    XCTAssertEqual(testTravelPartner!.profilePicture, "profile")
    
    XCTAssertEqual(testTravelPartnerNoProfile!.profilePicture, "")

  }
  
  func testParseTravelPartnerlData_invalid(){
    let testTravelPartner: TravelPartner? = parseTravelPartnerData(id:"partner_id_42", data: testTravelPartnerData_invalidName1)
    let testTravelPartner2: TravelPartner? = parseTravelPartnerData(id: "partner_id_42", data: testTravelPartnerData_invalidName2)
    XCTAssertEqual(testTravelPartner, nil)
    XCTAssertEqual(testTravelPartner2, nil)
  }
  
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    //        self.measure {
    //            // Put the code you want to measure the time of here.
    //        }
  }
  
}



