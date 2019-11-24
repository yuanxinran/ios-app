//
//  EditTripAddMultiplePhotos.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 11/23/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import SwiftUI
import Photos
import PhotosUI


struct EditTripAddMultiplePhotos :  View {
  var onDismiss: () -> ()
  
  @State var isShowingImagePicker = false
  @State var imageList = [UIImage]()
  @State var imageAssetList = [PHAsset]()
  private var tripID : String
  private var viewModel : EditTripViewModel
  private var parent : TripDetailTestView
  
  init(tripID: String, parent: TripDetailTestView, onDismiss: @escaping () -> ()){
    PHPhotoLibrary.requestAuthorization({_ in return})
    self.tripID = tripID
    self.viewModel = EditTripViewModel()
    self.onDismiss = onDismiss
    self.parent = parent
  }
  
  func addPhotosToTrip(){
    self.viewModel.addPhotosToTrip(photos: imageAssetList, photoImages: imageList, tripID: tripID, coverImage: nil) { (result: [String], ignore)  in
      self.parent.refresh()
    }
    self.onDismiss()
  }
  
  
  var body: some View {
    ZStack {
      VStack(alignment: .leading) {
        VStack(alignment: .leading, spacing: 20.0){
          VStack(alignment: .leading, spacing: 10.0){
            Text("Upload Photos").font(.title).fontWeight(.bold)
            Button(action: {
              self.isShowingImagePicker.toggle()
            },label: {
              Text("Select Image").foregroundColor(GreenColor).sheet(isPresented: $isShowingImagePicker,content: {
  //              ImagePickerView(isPresented: self.$isShowingImagePicker, selectedImage: self.$imageList, selectedImageList: self.$imageAssetList)
                EditTripAddPhotosViewControllerWrapper(selectedImage: self.$imageList, selectedImageList: self.$imageAssetList)
              })
            }
            )
          }

          imageSelectorResult(self.imageList)

        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
  //      Spacer()
      }
      VStack {
        Spacer()
        HStack {
          Spacer()
          GreenButton("Add Photos").onTapGesture {
            self.addPhotosToTrip()
          }
        }
      }
    }.padding(.leading, UIScreen.main.bounds.width * 0.05)
    .padding(.trailing,UIScreen.main.bounds.width * 0.05)
    .padding(.top,20)
  }
}


