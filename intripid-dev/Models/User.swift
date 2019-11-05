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

struct User: Identifiable {
  var id : String
  var firstName: String
  var lastName : String
  var email : String
  var username: String
  var profilePicture : String
}


func getUserByID(userID: String, completion: @escaping (_ result: User?) -> Void) {
  var user : User?
  let userRef = Firestore.firestore().collection("users").document(userID)
  userRef.getDocument { (document, error) in
    if let document = document, document.exists {
      let data = document.data()
      if let data = data, let lastName = data["lastName"] as? String, let firstName=data["firstName"] as? String, let email = data["email"] as? String, let username = data["username"] as? String {
        user = User(id: userID, firstName: firstName, lastName: lastName, email: email, username: username, profilePicture: data["profilePicture"] as? String ?? "")
    } else {
      print("Document does not exist")
    }
     completion(user)
  }
}
}


//let usersData = [user_1, user_2, user_3, user_4, user_5]
