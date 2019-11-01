//
//  User.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/28/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation

struct User: Identifiable {
  var id = UUID()
  var firstName: String
  var lastName: String
  var profilePicture: String
  var travelPartners: [UUID]?
}

// TODO: get the trips from the API
let user_1 = User(firstName: "Zoe", lastName: "Teoh", profilePicture: "person_1", travelPartners: [])
let user_2 = User(firstName: "Anna", lastName: "Yuan", profilePicture: "person_2", travelPartners: [user_1.id])
let user_3 = User(firstName: "Joie", lastName: "Feng", profilePicture: "person_3", travelPartners: [user_1.id, user_2.id])
let user_4 = User(firstName: "Sandy", lastName: "Pan", profilePicture: "person_4", travelPartners: [user_1.id, user_2.id, user_3.id])
let user_5 = User(firstName: "Christina", lastName: "Chou", profilePicture: "person_5", travelPartners:[user_1.id, user_2.id, user_3.id, user_4.id])

let usersData = [user_1, user_2, user_3, user_4, user_5]
