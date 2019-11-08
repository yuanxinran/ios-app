//
//  TravelPartnerViewModel.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/5/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import Firebase
import Combine
import FirebaseFirestore

class TravelPartnerViewModel : ObservableObject {
  @Published var travelPartners = [TravelPartner]()
  var userID: String
  let currentUID = "mD6zAy0T0oh9qAYajiyE"

  
  init(){
    self.userID = currentUID
    let db = Firestore.firestore().collection("users").document(self.userID).collection("travelPartners")
    db.addSnapshotListener {(snap, error) in
      
      for i in snap!.documentChanges{
        let doc = i.document
        let data = doc.data() as JSONDictionary
        if i.type == .added {
          if let partner = parseTravelPartnerData(id: doc.documentID, data: data){
            print("the image url")
            self.travelPartners.append(partner)
          }
        }
        
        if i.type == .modified{
          for j in 0..<self.travelPartners.count{
            if self.travelPartners[j].id == i.document.documentID {
              if let firstName = i.document.get("firstName") as? String, let lastName = i.document.get("lastName") as? String{
                self.travelPartners[j].firstName = firstName
                self.travelPartners[j].lastName = lastName
                self.travelPartners[j].profilePicture = i.document.get("lastName") as? String ?? ""
              }
              }
            }
          }
      }
    }
  }
  
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
