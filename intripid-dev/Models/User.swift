//
//  User.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/28/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class UserSettings: ObservableObject {
  @Published var documentID = "mD6zAy0T0oh9qAYajiyE"
  @Published var userID = "xinrany"
}


let currentUserDoc = "mD6zAy0T0oh9qAYajiyE"

struct User: Identifiable {
  var id : String
  var firstName: String
  var lastName : String
  var email : String
  var username: String
  var profilePicture : String
}


