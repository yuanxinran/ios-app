////
////  TripPhotosView.swift
////  intripid-dev
////
////  Created by Zoe Teoh  on 10/29/19.
////  Copyright © 2019 zona. All rights reserved.
////
//
//import SwiftUI
//
//struct TripPhotosView: View {
//  var photos: [Photo]
//  private var array1: [Int]
//  private var array2: [Int]
//  private var array3: [Int]
//  
//  init(photos:[Photo]) {
//    self.photos = photos
//    
//    self.array1 = Array(stride(from: 0, through: self.photos.count-1, by: 3))
//    self.array2 = Array(stride(from: 1, through: self.photos.count-1, by: 3))
//    self.array3 = Array(stride(from: 2, through: self.photos.count-1, by: 3))
//  }
//  
//  
//  // TODO: select every other element instead of split middle
//  // TODO: create padding around the photos
//  var body: some View {
//    HStack(alignment: .top) {
//      VStack {
//        ForEach(array1, id: \.self) { index in
//          URLImage(url: self.photos[index].imagePath)
//        }
//      }
//      VStack {
//        ForEach(array2, id: \.self) { index in
//          URLImage(url: self.photos[index].imagePath)
//        }
//      }
//      VStack {
//        ForEach(array3, id: \.self) { index in
//          URLImage(url: self.photos[index].imagePath)
//        }
//      }
//      
////      VStack {
////        ForEach(photos[photos.count/3 + 1 ... 2*photos.count/3], id: \.self) { photo in
////          URLImage(url: photo.imagePath)
////
////        }
////      }
////      VStack {
////        ForEach(photos[2*photos.count/3 + 1 ..< photos.count], id: \.self) { photo in
////          URLImage(url: photo.imagePath)
////
////        }
////      }
//    }
//  }
//}
//
////struct TripPhotosView_Previews: PreviewProvider {
////  static var previews: some View {
////    Text("not available")
////  }
////}
