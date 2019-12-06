//
//  EditTripAddPhotos.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/6/19.
//  Copyright © 2019 zona. All rights reserved.
//


import Foundation
import SwiftUI
import Photos
import PhotosUI


struct EditTripAddPhotos :  View {
  var onDismiss: () -> ()
  
  @State var isShowingImagePicker = false
  @State var imageList = [UIImage]()
  @State var imageAssetList = [PHAsset]()
  private var tripID : String
  private var viewModel : EditTripViewModel
  private var parent : TripDetailView
  
  init(tripID: String, parent: TripDetailView, onDismiss: @escaping () -> ()){
    PHPhotoLibrary.requestAuthorization({_ in return})
    self.tripID = tripID
    self.viewModel = EditTripViewModel()
    self.onDismiss = onDismiss
    self.parent = parent
  }
  
  func addPhotosToTrip(){
    self.viewModel.addPhotosToTrip(photos: imageAssetList, photoImages: imageList, tripID: tripID, coverImage: nil) { (_ imageIDs: [String], _ imagesHQ: [UIImage])  in
      self.viewModel.addPhotoHQ(imageIDs: imageIDs, imageHQs: imagesHQ, tripID: self.tripID)
      self.parent.refresh()
      //self.viewModel.addHighQualityPhotosToTrip
    }
    self.onDismiss()
  }
  
  
  var body: some View {
    VStack(alignment: .leading) {
      VStack(alignment: .leading, spacing: 20.0){
        VStack(alignment: .leading, spacing: 10.0){
          Text("Upload Photos").font(.title).fontWeight(.bold)
          Button(action: {
            self.isShowingImagePicker.toggle()
          },label: {
            Text("Select Image").foregroundColor(GreenColor).sheet(isPresented: $isShowingImagePicker,content: {
              ImagePickerView(isPresented: self.$isShowingImagePicker, selectedImage: self.$imageList, selectedImageList: self.$imageAssetList)
            })
          }
          )
        }
        
        imageSelectorResult(self.imageList)
        
      }
      Spacer()
      VStack(alignment: .leading){
        Spacer()
        HStack(alignment: .top){
          Spacer()
          GreenButton("Add Photos").onTapGesture {
            self.addPhotosToTrip()
          }
        }
      }
      Spacer()
      
      
    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading).padding(.leading, UIScreen.main.bounds.width * 0.05).padding(.trailing,UIScreen.main.bounds.width * 0.05).padding(.top,20)
  }
}
