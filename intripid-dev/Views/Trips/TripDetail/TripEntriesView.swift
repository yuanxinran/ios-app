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
  private var tripID: String
  
  private let testPhotos: [String] = ["landscape", "portrait"]
  private var parent : TripDetailView
  
  init(entries:[Entry], tripID: String, parent: TripDetailView) {
    self.entries = entries
    
    self.array1 = Array(stride(from: 0, through: self.entries.count-1, by: 3))
    self.array2 = Array(stride(from: 1, through: self.entries.count-1, by: 3))
    self.array3 = Array(stride(from: 2, through: self.entries.count-1, by: 3))
    self.tripID = tripID
    self.parent = parent
  }
  
  
  // TODO: select every other element instead of split middle
  // TODO: create padding around the photos
  var body: some View {
    HStack(alignment: .top) {
      VStack {
        ForEach(array1, id: \.self) { index in
          NavigationLink(destination: TripEntryView(entries: self.entries, idx: index,tripID:self.tripID, parent: self.parent)) {
              EntryCell(entry: self.entries[index])
          }.buttonStyle(PlainButtonStyle())
        }
      }
      VStack {
        ForEach(array2, id: \.self) { index in
          NavigationLink(destination: TripEntryView(entries: self.entries, idx: index,tripID:self.tripID, parent: self.parent)) {
              EntryCell(entry: self.entries[index])
          }.buttonStyle(PlainButtonStyle())
        }
      }
      VStack {
        ForEach(array3, id: \.self) { index in
          NavigationLink(destination: TripEntryView(entries: self.entries, idx: index,tripID:self.tripID, parent: self.parent)) {
              EntryCell(entry: self.entries[index])
          }.buttonStyle(PlainButtonStyle())
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
