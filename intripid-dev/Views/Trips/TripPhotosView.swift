//
//  TripPhotosView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/29/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

struct TripPhotosView: View {
  let photos : [String]
  
  // TODO: select every other element instead of split middle
  // TODO: create padding around the photos
  var body: some View {
    HStack(alignment: .top) {
      VStack {
        ForEach(photos[0 ... photos.count/3], id: \.self) { photo in
          Image("\(photo)")
            .resizable()
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width/3)
            .clipped()
            .cornerRadius(10)
        }
      }
      VStack {
        ForEach(photos[photos.count/3 + 1 ... 2*photos.count/3], id: \.self) { photo in
          Image("\(photo)")
            .resizable()
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width/3)
            .clipped()
            .cornerRadius(10)
        }
      }
      VStack {
        ForEach(photos[2*photos.count/3 + 1 ..< photos.count], id: \.self) { photo in
          Image("\(photo)")
            .resizable()
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width/3)
            .clipped()
            .cornerRadius(10)
        }
      }
    }
  }
}

struct TripPhotosView_Previews: PreviewProvider {
  static var previews: some View {
    TripPhotosView(photos: tripsData[0].photos)
  }
}
