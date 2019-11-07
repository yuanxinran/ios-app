//
//  AddJournalView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/29/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

struct AddJournalView: View {
  var onDismiss: () -> ()
  
  private let colors = [
    [Color(red: 238.0 / 255, green: 156.0 / 255, blue: 167.0 / 255),
     Color(red: 255.0 / 255, green: 221.0 / 255, blue: 225.0 / 255)],
    [Color(red: 252.0 / 255, green: 92.0 / 255, blue: 125.0 / 255),
      Color(red: 106.0 / 255, green: 130.0 / 255, blue: 251.0 / 255)],
    [Color(red: 248.0 / 255, green: 181.0 / 255, blue: 0.0 / 255),
     Color(red: 252.0 / 255, green: 234.0 / 255, blue: 187.0 / 255)]
  ]
    
  @State var gradientStart: Color = Color(red: 22.0 / 255, green: 160.0 / 255, blue: 133.0 / 255)
  @State var gradientEnd: Color = Color(red: 244.0 / 255, green: 208.0 / 255, blue: 63.0 / 255)
  @State private var name: String = "Zoe"
  @State private var heading: String = ""
  @State private var journal: String = ""

    var body: some View {
      VStack {
        Text("Adding a Journal Entry")
          .font(.title)
          .fontWeight(.bold)
        ZStack {
          Rectangle()
            .fill(LinearGradient(
              gradient: .init(colors: [gradientStart, gradientEnd]),
              startPoint: .init(x: 0.5, y: 0),
              endPoint: .init(x: 0.5, y: 0.6)
            ))
            .frame(width: 300, height: 500)
            .cornerRadius(20)
          VStack (alignment: .leading){
            TextField("Enter your Heading!", text: $heading)
              .font(.headline)
              .foregroundColor(.white)
              .padding(.bottom, 20)
            TextField("Enter your Body!", text: $journal)
              .font(.body)
            .foregroundColor(.white)
            Spacer()
          }.padding(40)
        }.frame(width: 300, height: 500) //size of rectangle
        
        Button(action: {
          let colors = self.colors.randomElement()!
          self.gradientStart = colors[0]
          self.gradientEnd = colors[1]
          
//          print(self.colors.randomElement()![0], self.colors.randomElement()![1])
        }, label: {Text("Randomise Color!")})
        
        HStack {
          Button(action: { self.onDismiss() }) {
              Text("Dismiss")
          }
          Button(action: {}) {
            Text("Upload Journal")
          }
        }
      }
    }
}

struct AddJournalView_Previews: PreviewProvider {
    static var previews: some View {
        AddJournalView(onDismiss: {return})
    }
}
