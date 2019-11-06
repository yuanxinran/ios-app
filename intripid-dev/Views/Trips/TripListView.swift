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
  init(urlString: String){
    self.url = URL(string: urlString)!
  }
  
  var body: some View {
    RemoteImage(url: url, errorView: { error in
       Image("person_2")
       .resizable()
       .scaledToFill()
       .frame(width: 30, height: 30)
       .clipShape(Circle())
    }, imageView: { image in
      image
      .resizable()
      .scaledToFill()
      .frame(width: 30, height: 30)
      .clipShape(Circle())
//      .offset(CGSize(width: 20, height: 0))
    }, loadingView: {
      Image("person_2")
      .resizable()
      .scaledToFill()
      .frame(width: 30, height: 30)
      .clipShape(Circle())
//      .offset(CGSize(width: 20, height: 0))
    })
  }
}




struct TripListTravelPartnersView : View{
  let profileImages: [String]
  var body: some View {
    // Travel Partners
    ZStack{
      // TODO: ForEach(trip.travelbuddy) -> get photo
      ForEach(self.profileImages, id:\.self) { imageURL in
        TripListTravelPartnerImageCached(urlString: imageURL)

      }
      
    }
  }
  
}

struct TripListView: View {
  let trips: [Trip]
  
  var body: some View {
    //Trips
    List {
      ForEach(trips) { trip in
        NavigationLink(destination: TripDetailView(trip: trip)) {
          
          // Cover Photo
           CoverImageCached(urlString: trip.coverImage?.imagePath ?? "")
   
          // Trip Information
          VStack (alignment: .leading){
            Text("\(trip.title)")
            Text("\(self.trips.count)")
            Text("\(trip.startDate.formatDate())")
              .font(.caption)
              .padding(.top, 10)
            
            Text("\(trip.photoNum) Photos, \(trip.journalNum) Journals")
              .font(.caption)
            
            // Travel Partners
            TripListTravelPartnersView(profileImages: trip.travelPartnerImages)
          }
        }
      }
    }.edgesIgnoringSafeArea(.all)
  }
}

struct TripListView_Previews: PreviewProvider {
    static var previews: some View {
      TripListView(trips: tripsData)
    }
}
