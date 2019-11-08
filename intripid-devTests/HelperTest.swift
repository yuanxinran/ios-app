//
//  HelperTest.swift
//  intripid-devTests
//
//  Created by Anna Yuan on 11/8/19.
//  Copyright © 2019 zona. All rights reserved.
//

import XCTest
import Firebase
import FirebaseFirestore
import SwiftUI
import MapKit
import PhotosUI
import Photos
@testable import intripid

let cmulocation = CLLocation(latitude: 40.442806, longitude: -79.9430169)

class HelperTest: XCTestCase {

  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testLocationHelper() {
    cmulocation.geocode{(placemark, error) in
      XCTAssertNotEqual(placemark, nil)
      XCTAssertNotEqual(placemark, [])
      XCTAssertEqual(placemark![0].country,"United States")
      XCTAssertEqual(placemark![0].locality,"Pittsburgh")
      XCTAssertEqual(placemark![0].administrativeArea,"PA")
    }

  }
  
  func testDateHelper() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    let testDate1 = (formatter.date(from: "2016/10/08 22:31"))
    XCTAssertNotEqual(testDate1,nil)
    let testDate1NS = testDate1 as! NSDate
    let testDate2 = (formatter.date(from: "2016/10/10 22:31"))
    XCTAssertNotEqual(testDate2,nil)
    XCTAssertEqual(testDate1NS.formatDate(),"10/08/2016")

    
    let datesBetween = Date.dates(from: testDate1!, to: testDate2!)
    XCTAssertEqual(datesBetween.count, 3)
    let datesBetween2 = Date.dates(from: testDate1!, to: testDate1!)
    XCTAssertEqual(datesBetween2.count, 1)

  }
  
  
  
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    //        self.measure {
    //            // Put the code you want to measure the time of here.
    //        }
  }
  
}

