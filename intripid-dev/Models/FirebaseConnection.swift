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

class FirbaseConnection {

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
    //TODO: ADD PHOTOS TO THE CLOUD STORAGE
    
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
        self.addPhotosToTrip(photos: photos, photoImages: photoImages, tripRef: ref!, userID: userID,coverImage: coverImage) { (result: [String]) in

          for r in result {
            print(r)
          }
          completion(docID)
        }
      }
    }
  }
  
  

  func addPhotosToTrip(photos: [PHAsset], photoImages: [UIImage], tripRef: DocumentReference, userID: String, coverImage: Int, completion: @escaping (_ result:[String]) -> Void){
    let storage = Storage.storage()
    var imageIDs = [String]()
    for num in (0 ..< photos.count){
      var photoRef: DocumentReference? = nil
      let photo = photos[num]
      let photoImage = photoImages[num]
      print("photo \(num)")
      photo.getLocationDataForPhoto {
        (result: PhotoLocation?, error: Error?) in
        print("photo location result \(result)")
        
        if let result = result {
          photoRef = tripRef.collection("photos").addDocument(data: [
            "dateTime": photo.creationDate ?? NSNull(),
            "imagePath": "",
            "photoLocation":[
              "city": result.city,
              "country": result.country,
              "geocoding": GeoPoint(latitude: result.latitude, longitude: result.longitude)
            ]
          ]){ err in
            if let err = err {
              print("\(err) encountered")
              return
            } else {
              print("photoid: \(photoRef!.documentID)")
              let storageRef = storage.reference()
              // Create a reference to 'images/mountains.jpg'
              let imageRef = storageRef.child("\(userID)/\(photoRef!.documentID).jpg")
              
              let uploadData = photoImage.pngData()
              if let uploadData = uploadData {
                _ = imageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                  guard metadata != nil else {
                    return
                  }
                  imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                      return
                    }
                    photoRef!.updateData([
                      "imagePath": "\(downloadURL)"
                    ]) { err in
                      if let err = err {
                        print("Error encountered when updating the trip information \(err)")
                      } else {
                        imageIDs.append(photoRef!.documentID)
                        if num == coverImage {
                          tripRef.updateData([
                            "coverImage": "\(photoRef!.documentID)"
                          ]) { err in
                            if let err = err {
                              print("Error encountered when updating the trip information \(err)")
                            }
                          }
                        }
                      }
                    }
                  }
                }
              } else {
                return
              }
            }
          }
          
          
        }
      }
    }
    completion(imageIDs)
    
  }



}


