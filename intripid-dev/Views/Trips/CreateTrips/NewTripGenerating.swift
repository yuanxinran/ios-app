//
//  NewTripGenerating.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/4/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import SwiftUI
import Photos
import PhotosUI

struct NewTripGenerating: View {

  var title: String
  var travelPartners: [String]
  var imageList: [UIImage]
  var imageAssetList: [PHAsset]
  var coverImage: Int = 0
  @State var creationCompleted: Bool = false
  @EnvironmentObject var settings: UserSettings
  
  init(title: String, travelPartners: [String], imageList:[UIImage], imageAssetList: [PHAsset], coverImage: Int){
    let database = FirbaseConnection()
    self.title = title
    self.travelPartners = travelPartners
    self.imageList = imageList
    self.imageAssetList = imageAssetList
    self.coverImage = coverImage
    database.createTrip(title: title, travelPartners: travelPartners, photos: imageAssetList, photoImages: imageList, coverImage: coverImage, userID: "xinrany") {(result: String?) in
      if let result = result {
        print("added docu \(result)")
      } else {
        print("failed")
      }
    }
  }
  
  var body : some View {
    Text("Generating The Trip")
    
  }
  
  
}
