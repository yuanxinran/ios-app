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
  
  var body: some View {
    ColoredButton(self.text,
                  backgroundColor: Color(.sRGB, red: 52.0/255.0, green: 121/255.0, blue: 137.0/255.0, opacity: 1.0),
                  foregroundColor: .white
    )
  }
  
}


struct RedButton : View {
  private let text: String

  init(_ txt: String){
    self.text = txt
  }
  
  var body: some View{
    ColoredButton(self.text,
                  backgroundColor: Color(.sRGB, red: 173.0/255.0, green: 49/255.0, blue: 17.0/255.0, opacity: 1.0),
                  foregroundColor: .white
    )
  }
  
}

struct GreyedButton : View {
  private let text: String
  
  init(_ txt: String){
    self.text = txt
  }
  
  var body: some View{
    ColoredButton(self.text,
                  backgroundColor: Color(.sRGB, red: 230/255.0, green: 230/255.0, blue: 230/255.0, opacity: 1.0),
                  foregroundColor: .gray
    )
  }
  
}

struct ColoredButton : View {
  private let text: String
  private let backgroundColor: Color
  private let foregroundColor: Color

  init(_ txt: String, backgroundColor: Color, foregroundColor: Color) {
    self.text = txt
    self.backgroundColor = backgroundColor
    self.foregroundColor = foregroundColor
  }
  
  var body: some View{
    Text(self.text)
      .font(.body)
    .fontWeight(.bold)
    .font(.title)
    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    .background(self.backgroundColor)
    .foregroundColor(self.foregroundColor)
    .cornerRadius(20)
  }
  
}
