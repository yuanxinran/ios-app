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
  let parent: TripDetailView
  @State var journalModalDisplayed = false
  @State var photoModalDisplayed = false
  @State var editModalDisplayed = false
  @State var editTripModalDisplayed = false
  @State var showAdd = false
  
  private let gradientStart = Color(red: 0.0 / 255, green: 0.0 / 255, blue: 0.0 / 255, opacity: 0.75)
  private let gradientMid = Color(red: 0.0 / 255, green: 0.0 / 255, blue: 0.0 / 255, opacity: 0)
  private let gradientEnd = Color(red: 0.0 / 255, green: 0.0 / 255, blue: 0.0 / 255, opacity: 0.75)
  
  var body: some View {
    ZStack (alignment: .leading) {
      // Cover Photo
      CoverImageDetailCached(urlString: trip.coverImage?.imagePath ?? "")
      
      // Translucent screen
      Rectangle()
        .fill(LinearGradient(gradient: Gradient(colors: [gradientStart, gradientMid, gradientEnd]), startPoint: .top, endPoint: .bottom))
      
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
          
          Button(action: { self.editTripModalDisplayed = true }) {
            Text("Edit Trip")
          }.font(.caption)
            .padding(5)
            .padding(.leading, 15)
            .padding(.trailing, 15)
            .background(Color(.sRGB, red: 200/255, green: 200/255, blue: 200/255, opacity: 0.3))
            .clipShape(Capsule())
            .sheet(isPresented: $editTripModalDisplayed) {
              EditTrip(trip: self.trip, parent: self.parent, onDismiss: {
                self.editTripModalDisplayed = false
              })
          }
          
//          Button(action: { self.editModalDisplayed = true }) {
//            Text("Add Photo")
//          }.font(.caption)
//            .padding(5)
//            .padding(.leading, 15)
//            .padding(.trailing, 15)
//            .background(Color(.sRGB, red: 200/255, green: 200/255, blue: 200/255, opacity: 0.3))
//            .clipShape(Capsule())
//            .sheet(isPresented: $editModalDisplayed) {
//            EditTripAddMultiplePhotos(tripID: self.trip.id, parent: self.parent, onDismiss: {
//              self.editModalDisplayed = false
//            })
//          }
          
          VStack {
            Button(action: { self.showAdd = true }) {
              Text("Add Entry")
            }.font(.caption)
              .padding(5)
              .padding(.leading, 15)
              .padding(.trailing, 15)
              .background(Color(.sRGB, red: 200/255, green: 200/255, blue: 200/255, opacity: 0.3))
              .clipShape(Capsule())
          }.actionSheet(isPresented: self.$showAdd) {
              ActionSheet(
                  title: Text("Add Entry"),
                  message: Text("Add photo or journal to your trip"),
                  buttons: [
                      .cancel { },
                      .default(Text("Add Photo")){self.editModalDisplayed = true},
                      .default(Text("Add Journal")){self.editModalDisplayed = true; self.journalModalDisplayed = true}
                  ]
              )
          }.sheet(isPresented: $editModalDisplayed) {
            if (!self.journalModalDisplayed) {
              EditTripAddMultiplePhotos(tripID: self.trip.id, parent: self.parent, onDismiss: {
                self.editModalDisplayed = false
              })
            } else {
              EditTripAddJournal(tripID: self.trip.id, parent: self.parent, startDate: self.trip.startDate, endDate: self.trip.endDate, onDismiss: {
                self.editModalDisplayed = false
                self.journalModalDisplayed = false
              })
            }
             
          }
          
          
                    
//          Button(action: { self.journalModalDisplayed = true }) {
//            Text("Add Journal")
//          }.font(.caption)
//            .padding(5)
//            .padding(.leading, 15)
//            .padding(.trailing, 15)
//            .background(Color(.sRGB, red: 200/255, green: 200/255, blue: 200/255, opacity: 0.3))
//            .clipShape(Capsule())
//            .sheet(isPresented: $journalModalDisplayed) {
//              EditTripAddJournal(tripID: self.trip.id, parent: self.parent, startDate: self.trip.startDate, endDate: self.trip.endDate, onDismiss: {
//                self.journalModalDisplayed = false
//              })
//          }
        }
        
      }.foregroundColor(.white)
        .padding() //padding for cover text
    }.frame(height:CGFloat(250)) //set height to 250, which is height of cover image
  }
}

//struct TripCoverView_Previews: PreviewProvider {
//  static var previews: some View {
//    Text("not available")
//  }
//}
