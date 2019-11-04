//
//  TripListView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/27/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

struct TripListView: View {
  let trips: [Trip]
  
  var body: some View {
    //Trips
    List {
      ForEach(trips) { trip in
        NavigationLink(destination: TripDetailView()) {
          
          // Cover Photo
          Image(trip.cover)
            .resizable()
            .scaledToFill()
            .frame(width: 120, height: 120)
            .clipped()
            .cornerRadius(10)
          
          // Trip Information
          VStack (alignment: .leading){
            Text("\(trip.title)")
            Text("\(trip.startDate)")
              .font(.caption)
              .padding(.top, 10)
            Text("50 Photos, 3 Journals")
              .font(.caption)
            
            // Travel Partners
            ZStack{
              // TODO: ForEach(trip.travelbuddy) -> get photo
              Image("person_1")
                .resizable()
                .scaledToFill()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
              Image("person_2")
                .resizable()
                .scaledToFill()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
                .offset(CGSize(width: 20, height: 0))
            }
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
