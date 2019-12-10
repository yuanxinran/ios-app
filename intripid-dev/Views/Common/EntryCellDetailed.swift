//
//  EntryCellDetailed.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 12/2/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

struct EntryCellDetailed: View{
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
          .frame(width: UIScreen.main.bounds.width - 8)
      } else {
        ZStack {
          Rectangle()
            .fill(LinearGradient(
              gradient: .init(colors: [gradientStart, gradientEnd]),
              startPoint: .init(x: 0.5, y: 0),
              endPoint: .init(x: 0.5, y: 0.6)
            ))
            .cornerRadius(10)
          VStack (alignment: .leading){
            Text("\(entry.journal!.title)")
              .font(.title)
              .fontWeight(.bold)
              .padding(.bottom, 10)
            Text("\(entry.journal!.content)").font(.body)
          }.padding(20)
        }
      }
    }
    
  }
}



