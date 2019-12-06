//
//  Button.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/3/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import SwiftUI


let GreenColor = Color(.sRGB, red: 52.0/255.0, green: 121/255.0, blue: 137.0/255.0, opacity: 1.0)

struct GreenButton : View {
  private let text: String

  init(_ txt: String){
    self.text = txt
  }
  
  var body: some View{
    Text(self.text)
      .font(.body)
    .fontWeight(.bold)
    .font(.title)
    .padding()
    .background(Color(.sRGB, red: 52.0/255.0, green: 121/255.0, blue: 137.0/255.0, opacity: 1.0))
    .cornerRadius(20)
    .foregroundColor(.white)
    .padding(8)
  }
  
}


struct RedButton : View {
  private let text: String

  init(_ txt: String){
    self.text = txt
  }
  
  var body: some View{
    Text(self.text)
      .font(.body)
    .fontWeight(.bold)
    .font(.title)
    .padding()
    .background(Color(.sRGB, red: 173.0/255.0, green: 49/255.0, blue: 17.0/255.0, opacity: 1.0))
    .cornerRadius(20)
    .foregroundColor(.white)
    .padding(8)
  }
  
}

struct GreyedButton : View {
  private let text: String

  init(_ txt: String){
    self.text = txt
  }
  
  var body: some View{
    Text(self.text)
      .font(.body)
    .fontWeight(.bold)
    .font(.title)
    .padding()
    .background(Color(.sRGB, red: 255/255.0, green: 255/255.0, blue: 255/255.0, opacity: 1.0))
    .cornerRadius(20)
    .foregroundColor(.gray)
    .padding(8)
  }
  
}

//(.sRGB, red: 52.0/255.0, green: 121/255.0, blue: 137.0/255.0, opacity: 1.0)
