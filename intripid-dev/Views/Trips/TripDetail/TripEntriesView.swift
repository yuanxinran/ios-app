//
//  TripEntriesView.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/7/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

struct TripEntriesView: View {
  var entries: [Entry]
  private var array1: [Int]
  private var array2: [Int]
  private var array3: [Int]
  
  private let testPhotos: [String] = ["landscape", "portrait"]
  
  init(entries:[Entry]) {
    self.entries = entries
    
    self.array1 = Array(stride(from: 0, through: self.entries.count-1, by: 3))
    self.array2 = Array(stride(from: 1, through: self.entries.count-1, by: 3))
    self.array3 = Array(stride(from: 2, through: self.entries.count-1, by: 3))
  }
  
  
  // TODO: select every other element instead of split middle
  // TODO: create padding around the photos
  var body: some View {
    HStack(alignment: .top) {
      VStack {
//
//        ForEach(testPhotos, id: \.self) { photo in
//          Image(photo)
//          .resizable()
//          .scaledToFit()
//          .frame(width: UIScreen.main.bounds.width/3)
//        }
        
        ForEach(array1, id: \.self) { index in
          EntryCell(entry: self.entries[index])
//          URLImage(url: self.photos[index].imagePath)
        }
      }
      VStack {
        ForEach(array2, id: \.self) { index in
          EntryCell(entry: self.entries[index])
//          URLImage(url: self.photos[index].imagePath)
        }
      }
      VStack {
        ForEach(array3, id: \.self) { index in
          EntryCell(entry: self.entries[index])
//          URLImage(url: self.photos[index].imagePath)
        }
      }
    }
  }
}

//struct TripEntriesView_Previews: PreviewProvider {
//  static var previews: some View {
//    Text("not available")
//  }
//}
