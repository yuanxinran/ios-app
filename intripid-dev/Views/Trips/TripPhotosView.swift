//
//  TripPhotosView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/29/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

struct TripPhotosView: View {
  let photos : [Photo]
  
  // TODO: select every other element instead of split middle
  // TODO: create padding around the photos
  var body: some View {
    HStack(alignment: .top) {
      VStack {
        ForEach((0 ..< photos.count), id: \.self) { index in
          URLImage(url: self.photos[index].imagePath)
        }
      }
      VStack {
        ForEach((0 ..< photos.count), id: \.self) { index in
          URLImage(url: self.photos[index].imagePath)
        }
      }
      VStack {
        ForEach((0 ..< photos.count), id: \.self) { index in
              
          URLImage(url: self.photos[index].imagePath)
            
        }
      }
      
//      VStack {
//        ForEach(photos[photos.count/3 + 1 ... 2*photos.count/3], id: \.self) { photo in
//          URLImage(url: photo.imagePath)
//
//        }
//      }
//      VStack {
//        ForEach(photos[2*photos.count/3 + 1 ..< photos.count], id: \.self) { photo in
//          URLImage(url: photo.imagePath)
//
//        }
//      }
    }
  }
}

struct TripPhotosView_Previews: PreviewProvider {
  static var previews: some View {
    Text("not available")
  }
}
