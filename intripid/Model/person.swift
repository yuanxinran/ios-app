//
//  Person.swift
//  intripid
//
//  Created by Anna Yuan on 10/22/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation

class Person {
  var lastName: String
  var firstName: String
  var profilePicture: String?
  
  init(lastName: String, firstName: String, profilePicture: String? ){
   self.lastName = lastName
   self.firstName = firstName
   self.profilePicture = profilePicture
  }

}
