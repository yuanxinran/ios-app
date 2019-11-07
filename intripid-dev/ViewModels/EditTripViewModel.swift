//
//  FirebaseConnection.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/4/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Photos
import PhotosUI
import FirebaseStorage
import SwiftUI


extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
}

class EditTripViewModel {

  var ref: DocumentReference? = nil
  var db: Firestore!


  init(){
    db = Firestore.firestore()
  }
  
  func createTrip(title: String, travelPartners: [String], photos: [PHAsset], photoImages: [UIImage], coverImage: Int, userID: String, completion: @escaping (_ result:String?) -> Void){
    var ref: DocumentReference? = nil
    var docID: String? = nil
    var startDate: NSDate? = nil
    var endDate: NSDate? = nil
    
    let sortedPhotos = photos.filter{ $0.creationDate != nil }.sorted {
      ($0.creationDate!) < ($1.creationDate!)
    }
    if sortedPhotos.count > 0 {
      if let date = sortedPhotos[0].creationDate {
        startDate = date as NSDate
      }
      startDate = sortedPhotos[0].creationDate! as NSDate
      if let lastPhoto = sortedPhotos.last, let date = lastPhoto.creationDate {
        endDate = date as NSDate
      }
    }
    ref = db.collection("trips").addDocument(data: [
      "title": title,
      "travelPartners": travelPartners,
      "startDate": startDate ?? NSNull(),
      "endDate": endDate ?? NSNull(),
    ]) { err in
      if let err = err {
        print("Error adding document: \(err)")
      } else {
        print("Trip added with ID: \(ref!.documentID)")
        
        docID = ref!.documentID
        self.addPhotosToTrip(photos: photos, photoImages: photoImages, tripID: docID!, coverImage: coverImage) { (result: [String]) in

          for r in result {
            print(r)
          }
          completion(docID)
        }
      }
    }
  }
  
    
  func addJournalToTrip(title: String, content: String, startColor: String, endColor: String, dateTime: NSDate, tripID: String, completion: @escaping (_ result:String) -> Void){
      var journalRef: DocumentReference? = nil
      journalRef = db.collection("trips").document(tripID).collection("journals").addDocument(data: [
        "title": title,
        "content": content,
        "dateTime": dateTime,
        "startColor": startColor,
        "endColor": endColor
        
      ]) { err in
      if let err = err {
        print("getting error when creating photos : \(err)")
        return
      }
        
      completion(journalRef!.documentID)
    }
  }
    
  

  func addPhotosToTrip(photos: [PHAsset], photoImages: [UIImage], tripID: String, coverImage: Int?, completion: @escaping (_ result:[String]) -> Void){
    let tripRef = db.collection("trips").document(tripID)
    let storage = Storage.storage()
    var imageIDs = [String]()
//    let locations = [PhotoLocation]()
    let dispatchGroup = DispatchGroup()
    for num in (0 ..< photos.count){
      var photoRef: DocumentReference? = nil
      let photo = photos[num]
      let photoImage = photoImages[num]
      dispatchGroup.enter()
      photo.getLocationDataForPhoto {
        (result: PhotoLocation?, error: Error?) in
        var data : [String : Any]
        if let result = result {
          //the photo has location information
          data =  ["dateTime": photo.creationDate ?? NSNull(), "imagePath": "",
                   "photoLocation":[
                       "city": result.city,
                       "state": result.state,
                       "country": result.country,
                       "geocoding": GeoPoint(latitude: result.latitude, longitude: result.longitude)]]
          
        } else {
          data =  ["dateTime": photo.creationDate ?? NSNull(), "imagePath": "",
                            "photoLocation": NSNull()]
        }

        photoRef = tripRef.collection("photos").addDocument(data: data){ err in
          if let err = err {
            print("getting error when creating photos : \(err)")
            dispatchGroup.leave()
            return
          } else {
            let storageRef = storage.reference()
            let imageRef = storageRef.child("tripPhotos/\(photoRef!.documentID).jpg")
            
            let uploadData = photoImage.jpegData(compressionQuality: 1.0)
            if let uploadData = uploadData {
              _ = imageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                imageRef.downloadURL { (url, error) in
                  guard let downloadURL = url else {
                    dispatchGroup.leave()
                    return
                  }
                  photoRef!.updateData([
                    "imagePath": "\(downloadURL)"
                  ]) { err in
                    if let err = err {
                      dispatchGroup.leave()
                      print("Error encountered when updating the trip information \(err)")
                    } else {
                      imageIDs.append(photoRef!.documentID)
                      if let coverImage = coverImage, num == coverImage {
                        tripRef.updateData([
                          "coverImage": "\(photoRef!.documentID)"
                        ]) { err in
                          if let err = err {
                            dispatchGroup.leave()
                            print("Error encountered when updating the trip information \(err)")
                          }
                          //coverimage case
                          //finished uploading the photo to the storage and reference to the database
                          dispatchGroup.leave()
                        }
                      } else {
                        //finished uploading the photo (not cover image)
                        dispatchGroup.leave()
                      }
                    }
                  }
                }
              }
            } else {
              print("couldn't convert the photo to data")
              dispatchGroup.leave()
              return
            }
          }
        }
      }
    }
    
    dispatchGroup.notify(queue: DispatchQueue.global()) {
      completion(imageIDs)
    }
    
  }



}



