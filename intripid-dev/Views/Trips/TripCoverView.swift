//
//  TripCoverView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/29/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

struct TripCoverView: View {
  let trip: Trip
  
  @State var journalModalDisplayed = false
  @State var photoModalDisplayed = false
  
  var body: some View {
    ZStack (alignment: .leading) {
      Image(trip.cover)
        .resizable()
        .scaledToFill()
        .frame(height: CGFloat(250))
        .clipped()
      VStack (alignment: .leading) {
        Spacer() // push content to bottom align with cover image
        Text(trip.title)
          .font(.title)
          .fontWeight(.bold)
        // TODO: figure out how to convert NSDate into a String
        Text("October 27, 2019 - October 31, 2019")
        
        HStack {
          // TODO: convert to for loop
          Image("person_1")
            .resizable()
            .scaledToFill()
            .frame(width: CGFloat(40), height: CGFloat(40))
            .clipShape(Circle())
          //.stroke(Color.white)
          Image("person_2")
            .resizable()
            .scaledToFill()
            .frame(width: CGFloat(40), height: CGFloat(40))
            .clipShape(Circle())
          Spacer()
          
          Button(action: {}) {
            Text("Edit")
          }.font(.caption)
            .padding(5)
            .padding(.leading, 15)
            .padding(.trailing, 15)
            .background(Color(.sRGB, red: 200/255, green: 200/255, blue: 200/255, opacity: 0.3))
            .clipShape(Capsule())
          
//          Button(action: {}) {
//            Text("Add")
//          }.font(.caption)
//            .padding(5)
//            .padding(.leading, 15)
//            .padding(.trailing, 15)
//            .background(Color(.sRGB, red: 200/255, green: 200/255, blue: 200/255, opacity: 0.3))
//            .clipShape(Capsule())
          
          Button(action: { self.photoModalDisplayed = true }) {
              Text("Add Photo")
          }.font(.caption)
          .padding(5)
            .padding(.leading, 15)
          .padding(.trailing, 15)
          .background(Color(.sRGB, red: 200/255, green: 200/255, blue: 200/255, opacity: 0.3))
          .clipShape(Capsule())
            .sheet(isPresented: $photoModalDisplayed) {
              AddPhotosView(onDismiss: {
                  self.photoModalDisplayed = false
              })
          }
          
          Button(action: { self.journalModalDisplayed = true }) {
                       Text("Add Journal")
                   }.font(.caption)
                   .padding(5)
            .padding(.leading, 15)
                   .padding(.trailing, 15)
                   .background(Color(.sRGB, red: 200/255, green: 200/255, blue: 200/255, opacity: 0.3))
                   .clipShape(Capsule())
                     .sheet(isPresented: $journalModalDisplayed) {
                       AddJournalView(onDismiss: {
                           self.journalModalDisplayed = false
                       })
                   }
        }
        
      }.foregroundColor(.white)
        .padding() //padding for cover text
    }.frame(height:CGFloat(250)) //set height to 250, which is height of cover image
  }
}

struct TripCoverView_Previews: PreviewProvider {
  static var previews: some View {
    TripCoverView(trip: tripsData[0])
  }
}
