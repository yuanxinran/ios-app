//
//  EditTravelPartnerViewModel.swift
//  intripid-dev
//
//  Created by Anna Yuan on 12/11/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Photos
import PhotosUI
import FirebaseStorage
import SwiftUI


class EditTravelPartnerViewModel {

  var ref: DocumentReference? = nil
  var db: Firestore!
  var userID: String
  let currentUID = "mD6zAy0T0oh9qAYajiyE"


  init(){
    db = Firestore.firestore()
    self.userID = currentUID
  }

  func createTravelPartner(lastName: String, firstName: String, photo: PHAsset, photoImage: UIImage,completion: @escaping (_ result:String?) -> Void){
    
    let userRef = db.collection("users").document(self.userID)
    let storage = Storage.storage()
    var ref: DocumentReference? = nil
    var docID: String? = nil
    ref = userRef.collection("travelPartners").addDocument(data: [
    "lastName": lastName,
    "firstName": firstName,
    "profilePicture": "",
  ]) { err in
    if let err = err {
      print("Error adding document: \(err)")
      completion("\(firstName) not added")
    } else {
      print("TravelPartner added with ID: \(ref!.documentID)")
      
      docID = ref!.documentID
      let storageRef = storage.reference()
      let imageRef = storageRef.child("profileImages/\(docID!).jpg")
      
      let uploadData = photoImage.jpegData(compressionQuality: 0.3)
      if let uploadData = uploadData {
        _ = imageRef.putData(uploadData, metadata: nil) { (metadata, error) in
          imageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              return
            }
            ref!.updateData([
              "profilePicture": "\(downloadURL)"
            ]) { err in
              if let err = err {
                print("Error encountered when updating the trip information \(err)")
                completion("\(firstName) profile image not added")
              } else {
                completion("\(firstName) added")
              }
            }
          }
        }
      } else {
        print("couldn't convert the photo to data")
        completion("\(firstName) profile image not added")
      }
    }
  }
}
}
