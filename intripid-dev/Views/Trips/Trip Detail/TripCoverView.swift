//
//  TripCoverView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/29/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

struct TripCoverView: View {
  let trip: TripDetail
  let parent: TripDetailTestView
  @State var journalModalDisplayed = false
  @State var photoModalDisplayed = false
  
  var body: some View {
    ZStack (alignment: .leading) {
      // Cover Photo
      CoverImageDetailCached(urlString: trip.coverImage?.imagePath ?? "")
      VStack (alignment: .leading) {
        Spacer() // push content to bottom align with cover image
        Text(trip.title)
          .font(.title)
          .fontWeight(.bold)
        // TODO: figure out how to convert NSDate into a String
        Text("\(trip.startDate.formatDate()) - \(trip.endDate.formatDate())")
        
        HStack {
          TripListTravelPartnersView(profileImages: trip.travelPartners.map{$0.profilePicture})
          Spacer()
          
          Button(action: {}) {
            Text("Edit")
          }.font(.caption)
            .padding(5)
            .padding(.leading, 15)
            .padding(.trailing, 15)
            .background(Color(.sRGB, red: 200/255, green: 200/255, blue: 200/255, opacity: 0.3))
            .clipShape(Capsule())
          
          Button(action: { self.photoModalDisplayed = true }) {
              Text("Add Photo")
          }.font(.caption)
          .padding(5)
            .padding(.leading, 15)
          .padding(.trailing, 15)
          .background(Color(.sRGB, red: 200/255, green: 200/255, blue: 200/255, opacity: 0.3))
          .clipShape(Capsule())
            .sheet(isPresented: $photoModalDisplayed) {
              EditTripAddPhotos(tripID: self.trip.id, parent: self.parent, onDismiss: {
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
                      EditTripAddJournal(tripID: self.trip.id, parent: self.parent, startDate: self.trip.startDate, endDate: self.trip.endDate, onDismiss: {
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
    Text("not available")
  }
}
