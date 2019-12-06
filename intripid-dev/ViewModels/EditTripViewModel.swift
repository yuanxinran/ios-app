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
    ref = db.collection("trips").addDocument(data: [
      "title": title,
      "travelPartners": travelPartners,
      "startDate": NSNull(),
      "endDate": NSNull(),
      "archived": false,
    ]) { err in
      if let err = err {
        print("Error adding document: \(err)")
      } else {
        print("Trip added with ID: \(ref!.documentID)")
        
        docID = ref!.documentID
        self.addPhotosToTrip(photos: photos, photoImages: photoImages, tripID: docID!, coverImage: coverImage) { (_ imageIDs: [String], _ imagesHQ: [UIImage])  in
          completion(docID)
          self.addPhotoHQ(imageIDs: imageIDs, imageHQs: imagesHQ, tripID: docID!)
        }
      }
    }
  }
  
  func updateTrip(tripID: String, title: String, travelPartners:[String],completion: @escaping (_ result:String) -> Void){
    self.db.collection("trips").document(tripID).updateData([
             "title": title,
             "travelPartners": travelPartners,
           ]){
             (err) in
             if err != nil {
               print("errr...")
             }
             completion("updated")
           }
    
  }
  
  func deleteTrip(tripID: String, completion: @escaping (_ result:String) -> Void) {
    let tripRef = db.collection("trips").document(tripID)
    self.db.collection("trips").document(tripID).updateData([
             "archived": true,
           ]){
             (err) in
             if err != nil {
               print("errr...")
             }
             completion("archived")
           }
  }
  
  
  func deletePhoto(tripID: String, photoID: String, completion: @escaping (_ result:String) -> Void) {
    let tripRef = db.collection("trips").document(tripID)
    let photoCollection = tripRef.collection("photos")
    photoCollection.document(photoID).updateData([
      "archived": true,
    ]){
      (err) in
      if err != nil {
        print("errr...")
      }
      completion("archived")
    }
    

  }
  
  func deleteJournal(tripID: String, journalID: String, completion: @escaping (_ result:String) -> Void) {
    let tripRef = db.collection("trips").document(tripID)
    let photoCollection = tripRef.collection("journals")
    photoCollection.document(journalID).delete() { err in
        if let err = err {
            print("Error removing document: \(err)")
        } else {
            completion("deleted!")
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
  
    
  func updateDates(photos:[PHAsset], tripID: String, completion: @escaping () -> () ){
    var startDate: NSDate? = nil
    var endDate: NSDate? = nil
    var originalStart: NSDate? = nil
    var originalEnd: NSDate? = nil
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
    
    db.collection("trips").document(tripID).getDocument {
      (document, error) in
      if let document = document, document.exists {
        
        //Get original start date and end date
        let data = document.data() as! JSONDictionary
        if let start = data["startDate"] as? Timestamp{
          originalStart = start.dateValue() as NSDate
        }
        
        if let end = data["endDate"] as? Timestamp{
          originalEnd = end.dateValue() as NSDate
        }
        
        if let originalStart = originalStart as Date?, let originalEnd = originalEnd as Date?{
          if (startDate! as Date) > originalStart{
            //update start date
            startDate = originalStart as NSDate
          }
          if (endDate! as Date) < originalEnd {
            //update end date
            endDate = originalEnd as NSDate
          }
        }
        
        self.db.collection("trips").document(tripID).updateData([
          "startDate": startDate ?? NSNull(),
          "endDate": endDate ?? NSNull(),
        ]){
          (err) in
          if err != nil {
            print("errr...")
          } 
          completion()
        }
        
      } else {
        completion()
      }
    }
  }
  
  func addPhotoHQ(imageIDs: [String], imageHQs: [UIImage],  tripID: String){
    
//    let imageCollection = db.collection("trips").document(tripID).collection("photos")
//    let storage = Storage.storage()
//    for index in (0 ..< imageHQs.count){
//      let imageID = imageIDs[index]
//      let photoImage = imageHQs[index]
//
//      let storageRef = storage.reference()
//      let imageRef = storageRef.child("tripPhotosHQ/\(imageID).jpg")
//      let uploadDataHQ = photoImage.jpegData(compressionQuality: 1)
//
//      if let uploadDataHQ = uploadDataHQ {
//        _ = imageRef.putData(uploadDataHQ, metadata: nil) { (metadata, error) in
//          imageRef.downloadURL { (url, error) in
//            guard let downloadURL = url else {
//              return
//            }
//            imageCollection.document(imageID).updateData([
//              "imagePathHQ": "\(downloadURL)"
//            ])
//            print("successfully uploaded the high-quality image for \(imageID)")
//          }
//        }
//      } else {
//        print("lol cannot convert image to data")
//      }
//
//
//    }
  }
    
  

  func addPhotosToTrip(photos: [PHAsset], photoImages: [UIImage], tripID: String, coverImage: Int?, completion: @escaping (_ imageIDs: [String], _ imagesHQ: [UIImage]) -> Void){
    let tripRef = db.collection("trips").document(tripID)
    let storage = Storage.storage()
    var photoImagesHQ = [UIImage]()
    var imageIDs = [String]()
    let dispatchGroup = DispatchGroup()
    self.updateDates(photos: photos, tripID: tripID){
      () in
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
                     "archived": false,
                     "photoLocation":[
                         "city": result.city,
                         "state": result.state,
                         "country": result.country,
                         "geocoding": GeoPoint(latitude: result.latitude, longitude: result.longitude)]]
            
          } else {
            data =  ["dateTime": photo.creationDate ?? NSNull(),"archived": false, "imagePath": "",
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
              
              let uploadData = photoImage.jpegData(compressionQuality: 0.3)
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
                        photoImagesHQ.append(photoImage)
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
        completion(imageIDs, photoImagesHQ)
      }
    }
    
    
  }



}



