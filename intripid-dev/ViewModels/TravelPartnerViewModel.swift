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
  private var disposables = Set<AnyCancellable>()

  
  init(){
    self.userID = currentUID
    let db = Firestore.firestore().collection("users").document(self.userID).collection("travelPartners")
    db.addSnapshotListener {(snap, error) in
      
      for i in snap!.documentChanges{
        let doc = i.document
        if i.type == .added {
          if let firstName = doc.get("firstName") as? String, let lastName = doc.get("lastName") as? String{
            let partnerData = TravelPartner(id: doc.documentID, firstName: firstName, lastName: lastName, profilePicture: doc.get("profilePicture") as? String ?? "")
            self.travelPartners.append(partnerData)
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
