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
@testable import intripid

let testPhotoLocation: PhotoLocation = PhotoLocation(city: "Pittsburgh", country: "USA", latitude: -42.042, longitude: 42.042)
let testPhoto: Photo = Photo(dateTime: NSDate(), imagePath: "image_path_1", photoLocation: testPhotoLocation)

let testTripData:JSONDictionary = ["startDate": Timestamp(), "travelPartners": ["partner_1", "partner_2"], "coverImage": ["cover_image_1","cover_image_2"], "endDate":Timestamp(), "title": "Trip Test 1"]
let testTripData_invalidDate:JSONDictionary = ["startDate": NSDate(), "travelPartners": ["partner_1", "partner_2"], "coverImage": ["cover_image_1","cover_image_2"], "endDate":NSDate(), "title": "Trip Test 1"]
let testTripData_invalidTravelPartners_1:JSONDictionary = ["startDate": Timestamp(), "travelPartners": "invalid_partner", "coverImage": ["cover_image_1","cover_image_2"], "endDate":Timestamp(), "title": "Trip Test 1"]
let testTripData_invalidTravelPartners_2:JSONDictionary = ["startDate": Timestamp(), "travelPartners": [999, 991, 995], "coverImage": ["cover_image_1","cover_image_2"], "endDate":Timestamp(), "title": "Trip Test 1"]
let testTripData_invalidTitle_1:JSONDictionary = ["startDate": Timestamp(), "travelPartners": ["partner_1", "partner_2"], "coverImage": ["cover_image_1","cover_image_2"], "endDate":Timestamp(), "title": ["Trip Test 1"]]
let testTripData_invalidTitle_2:JSONDictionary = ["startDate": Timestamp(), "travelPartners": ["partner_1", "partner_2"], "coverImage": ["cover_image_1","cover_image_2"], "endDate":Timestamp(), "title": 999]

let testPhotoData:JSONDictionary = ["photoLocation": ["geocoding": GeoPoint(latitude: -42.024, longitude: 42.024), "city": "test_city", "country": "test_country"], "dateTime": Timestamp(), "imagePath": "image_path_1"]

//func parsePhotoData(id: String, data: JSONDictionary) -> Photo? {
//  var photoLocation : PhotoLocation?
//  if let locationData = data["photoLocation"] as? [String:AnyObject], let geopoint = locationData["geocoding"] as? GeoPoint, let city = locationData["city"] as? String, let country = locationData["country"] as? String {
//
//    photoLocation = PhotoLocation(city: city, country: country, latitude: geopoint.latitude, longitude: geopoint.longitude)
//  }
//  if let dateTime = data["dateTime"] as? Timestamp, let imagePath = data["imagePath"] as? String {
//    return Photo(dateTime: dateTime.dateValue() as NSDate, imagePath: imagePath, photoLocation: photoLocation)
//  }
//  return nil
//}

class TripViewModelTest: XCTestCase {
  
  func testing() {
    if let locationData = testPhotoData["photoLocation"] as? [String:AnyObject] {
      let geopoint = locationData["geocoding"] as? GeoPoint
      let city = locationData["city"] as? String
      let country = locationData["country"] as? String
    }
  }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
      
      print("****** Testing parseTripData *******")
      testParseTripData_valid()
      testParseTripData_invalidDate()
      testParseTripData_invalidTravelPartners()
      
      print("****** Testing parsePhotoData *******")
      testParsePhotoData_valid()
    }
  
  func testParseTripData_valid() {
    let testTrip:Trip? = parseTripData(id: "trip_id_42", data: testTripData, coverImage: testPhoto, photoNum: 42, journalNum: 420, images: ["image_1", "image_2", "image_3", "image_4"])
    XCTAssertNotEqual(testTrip, nil)
    XCTAssertEqual(testTrip!.docID, "trip_id_42")
    XCTAssertEqual(testTrip!.title, "Trip Test 1")
    XCTAssertEqual(testTrip!.photoNum, 42)
    XCTAssertEqual(testTrip!.journalNum, 420)
    XCTAssertEqual(testTrip!.travelPartnerImages, ["image_1", "image_2", "image_3", "image_4"])
    XCTAssertEqual(testTrip!.travelPartners, ["partner_1", "partner_2"])
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
  }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
