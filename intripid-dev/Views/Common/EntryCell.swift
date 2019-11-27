//
//  EntryCell.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/7/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import SwiftUI

struct EntryCell: View{
  var entry: Entry
  var gradientStart = Color("1s")
  var gradientEnd = Color("1e")
  init(entry: Entry) {
    if entry.type == "journal"{
      self.gradientStart = entry.journal!.gradientStart
      self.gradientEnd = entry.journal!.gradientEnd
    }
    self.entry = entry
  }
  
  var body: some View {
    VStack{
      if entry.type == "photo" {
        URLImage(url:entry.photo!.imagePath)
      } else {
        ZStack {
          Rectangle()
            .fill(LinearGradient(
              gradient: .init(colors: [gradientStart, gradientEnd]),
              startPoint: .init(x: 0.5, y: 0),
              endPoint: .init(x: 0.5, y: 0.6)
            )) //.frame(width: UIScreen.main.bounds.width/3,height: 160)
            .cornerRadius(10)
          VStack (alignment: .leading){
            Text("\(entry.journal!.title)").fontWeight(.bold)
          }.padding(8)
        } //.frame(width: UIScreen.main.bounds.width/3,height: 160)
        
      }
    }
    
  }
}


struct EntryCell_Previews: PreviewProvider {
  static var previews: some View {
//    EntryCell()
    Text("Not Available")
  }
}


