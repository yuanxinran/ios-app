//
//  TripListView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/27/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI
import RemoteImage


struct TripListTravelPartnerImageCached : View {
  var url : URL
  var offset: Int
  
  init(urlString: String, offset: Int){
    if let url = URL(string: urlString){
      self.url = url
    } else {
      self.url = URL(string: "https://firebasestorage.googleapis.com/v0/b/intripid-256611.appspot.com/o/profileImages%2Fzoe.png?alt=media&token=15078f14-d7a8-4fbf-a7b5-f1497ce829ed")!
    }
    self.url = URL(string: urlString)!
    self.offset = offset
  }
  
  var body: some View {
    RemoteImage(url: url, errorView: { error in
       Image("person_2")
       .resizable()
       .scaledToFill()
       .frame(width: 30, height: 30)
       .clipShape(Circle())
        .offset(CGSize(width: 20*self.offset, height: 0))
    }, imageView: { image in
      image
      .resizable()
      .scaledToFill()
      .frame(width: 30, height: 30)
      .clipShape(Circle())
      .offset(CGSize(width: 20*self.offset, height: 0))
    }, loadingView: {
      Image("person_2")
      .resizable()
      .scaledToFill()
      .frame(width: 30, height: 30)
      .clipShape(Circle())
      .offset(CGSize(width: 20*self.offset, height: 0))
    })
  }
}




struct TripListTravelPartnersView : View{
  let profileImages: [String]
  var body: some View {
    // Travel Partners
    ZStack{
      // TODO: ForEach(trip.travelbuddy) -> get photo
      ForEach((0 ..< self.profileImages.count), id:\.self) { index in
        TripListTravelPartnerImageCached(urlString: self.profileImages[index], offset: index)

      }
    }
  }
  
}

struct TripListView: View {
  var trips: [Trip]
  var numbers: String = ""
  var parent: TripView
  
  var body: some View {
    //Trips
    List {
      ForEach((0 ..< trips.count), id:\.self) { index in
        NavigationLink(destination: TripDetailTestView(tripID: self.trips[index].id, parent: self.parent)) {
          
          // Cover Photo
          CoverImageCached(urlString: self.trips[index].coverImage?.imagePath ?? "")
   
          // Trip Information
          VStack (alignment: .leading){
            Text("\(self.trips[index].title)").font(.headline).fontWeight(.bold)
            Text("\(self.trips[index].startDate.formatDate()) - \(self.trips[index].endDate.formatDate())")
              .font(.caption)
              .padding(.top, 10)

            
            Text("\(self.trips[index].photoNum) Photos, \(self.trips[index].journalNum) Journals")
              .font(.caption)
            
            // Travel Partners
            TripListTravelPartnersView(profileImages: self.trips[index].travelPartnerImages)
          }
        }
      }
    }.edgesIgnoringSafeArea(.all)
  }
}

struct TripListView_Previews: PreviewProvider {
    static var previews: some View {
      Text("no available")
    }
}
