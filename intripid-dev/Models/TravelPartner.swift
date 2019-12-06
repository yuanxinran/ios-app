//
//  travelPartner.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/2/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation


struct TravelPartner: Identifiable {
  var id : String
  var firstName: String
  var lastName : String
  var profilePicture : String
}



extension TravelPartner: Equatable {
  static func == (lhs: TravelPartner, rhs: TravelPartner) -> Bool {
    return
      lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName
  }
}
