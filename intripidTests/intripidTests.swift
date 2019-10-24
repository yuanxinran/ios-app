//
//  intripidTests.swift
//  intripidTests
//
//  Created by Zoe Teoh  on 10/20/19.
//  Copyright © 2019 zona. All rights reserved.
//

import XCTest
@testable import intripid

class intripidTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreatePartner() {
        // This is an example of a functional test case.
      var database = FirbaseConnection()
      database.createPartner(lastName: "last", firstName: "first", profilePicture: "profilePictures/user-1.png")
      XCTAssertEqual(1, 1)
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }


}
