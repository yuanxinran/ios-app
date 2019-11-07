//
//  NewTripSelectCover.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/3/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import SwiftUI
import Photos
import PhotosUI



struct imageSelectorResultSelectCoverImage : View{
  var image : UIImage
  var selected : Bool
  
  init(image: UIImage, num: Int, selectedNum: Int){
    self.image = image
    if num == selectedNum{
      self.selected = true
    } else {
      self.selected = false
    }
  }
  
  
  var body : some View{
    Image(uiImage: self.image)
      .resizable()
      .scaledToFill()
      .frame(width: UIScreen.main.bounds.width * 0.21,height: UIScreen.main.bounds.width * 0.21)
      .clipped()
      .cornerRadius(10)
      .overlay(RoundedRectangle(cornerRadius: 10)
        .stroke(selected ? GreenColor : Color.white, lineWidth: 4))
  }
}

struct imageSelectorResultSelectCover : View{
  var imageList: [UIImage]
  @Binding var coverImage:Int
  
  var body : some View{
    VStack{
      if self.imageList.count != 0 { //check that self.imageList is not empty
        ForEach(0 ... ((self.imageList.count-1)/4), id: \.self) { row in
          HStack {
            ForEach((row * 4 ..< self.imageList.count).prefix(4) , id: \.self) { num in
              imageSelectorResultSelectCoverImage(image: self.imageList[num], num: num, selectedNum: self.coverImage )
                .onTapGesture{
                  self.coverImage = num
              }
              
            }
          }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
      }
    }
  }
}

struct NewTripSelectCover: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @State private var clickedCreate = false
  @State private var createCompleted = false
  @State private var tripID = ""
  
  var title: String
  var travelPartners: [String]
  var imageList: [UIImage]
  var imageAssetList: [PHAsset]
  //  var imageURLList: [String]
  @State private var coverImage: Int = 0
  
  var btnBack : some View { Button(action: {
    self.presentationMode.wrappedValue.dismiss()
  }) {
    HStack {
      Text("Previous")
    }
    }
  }
  
  func createTrip(){
    let database = EditTripViewModel()
    self.clickedCreate = true
    
    database.createTrip(title: self.title, travelPartners: self.travelPartners, photos: self.imageAssetList, photoImages: self.imageList, coverImage: self.coverImage, userID: "xinrany") {(result: String?) in
      if let result = result {
        print("added docu \(result)")
        self.createCompleted = true
        self.tripID = result
        
      } else {
        print("failed")
      }
    }
    
  }
  
  var body: some View {
    VStack{
      if (clickedCreate) {
        VStack{
//          Image("generating").resizable().scaledToFit().frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.3).clipped()
//          Text("Generating Your Trip").font(.title)
          if createCompleted {
            NavigationLink(destination: TripDetailTestView(tripID: tripID)){
              GreenButton("GoToTrip")
            }
          } else {
            SplashScreen()
          }
        }
      } else {
        VStack{
          VStack(alignment: .leading, spacing: 20.0){
            Text("Select Cover Picture").font(.title).fontWeight(.bold)
            imageSelectorResultSelectCover(imageList: self.imageList, coverImage: self.$coverImage)
          }
          Spacer()
          VStack(alignment: .leading){
            HStack(alignment: .top){
              Spacer()
              Button(action: {self.createTrip()}) {
                GreenButton("Create Trip")
              }
            }
          }
          Spacer()
        }
        
      }
    }.navigationBarBackButtonHidden(true)
     .navigationBarItems(leading: btnBack)
      .navigationBarHidden(self.clickedCreate ? true : false)
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: self.clickedCreate ? .center : .topLeading).padding(.leading, UIScreen.main.bounds.width * 0.05).padding(.trailing, UIScreen.main.bounds.width * 0.05)
    
    
  }
}
