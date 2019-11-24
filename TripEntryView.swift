//
//  TripEntryView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 11/24/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

struct TripEntryView: View {
  
  @ObservedObject private var imageLoader = ImageLoader()
  
  var entries: [Entry]
  var idx: Int
  var url: String
  
  init(entries:[Entry], idx: Int) {
    self.entries = entries
    self.idx = idx
    self.url = entries[idx].photo!.imagePath
    self.imageLoader.load(url: url)
  }
  
  
    var body: some View {
      if let uiImage = self.imageLoader.downloadedImage {
        return Image(uiImage: uiImage)
        .resizable()
                .aspectRatio(uiImage.size.width/uiImage.size.height, contentMode: .fit)
        //        .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
        //        .frame(minWidth:0, idealWidth: UIScreen.main.bounds.width/3, maxWidth: .infinity, minHeight:0, maxHeight:.infinity)
                .clipped()
                .cornerRadius(5)
      }
      return Image("person_1")
      .resizable()
              .aspectRatio(contentMode: .fit)
      //        .scaledToFit()
              .frame(width: UIScreen.main.bounds.width)
      //        .frame(minWidth:0, idealWidth: UIScreen.main.bounds.width/3, maxWidth: .infinity, minHeight:0, maxHeight:.infinity)
              .clipped()
              .cornerRadius(5)
    }
}

//struct TripEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripEntryView()
//    }
//}
