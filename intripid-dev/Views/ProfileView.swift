//
//  ProfileView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/28/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI
import FirebaseStorage
import RemoteImage

// Simple wrapper to add in title "All trips with [PARTNER]"
struct FilteredTripListView: View {
  var trips: [Trip]
  var numbers: String = ""
  var parent: TripView
  var partnerName: String = ""
  
  var body: some View {
    VStack {
//      ZStack {
//        Image("trip_1")
//          .resizable()
//          .frame(height: 150)
//        Spacer()
//
//        Text("My Footsteps")
//          .font(.title)
//          .fontWeight(.bold)
//          .foregroundColor(.white)
//      }
      Text("Trips with " + partnerName)
        .font(.title)
        .fontWeight(.bold)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
        .padding(.leading, 20)
      TripListView(trips: trips, numbers: numbers, parent: parent)
    }.offset(x: 0, y: -50)
  }
}

struct ProfileView: View {
  @ObservedObject var travelPartners = TravelPartnerViewModel()
  @ObservedObject private var viewModel : TripViewModel
  
  init(){
    self.viewModel = TripViewModel(userID: currentUserDoc)
    print("[Profile] init")
    print(self.viewModel.trips)
    print(self.viewModel.trips.count)
  }
  
  func refresh(){
    self.viewModel.fetchData()
    print("[Profile] init")
    print(self.viewModel.trips)
    print(self.viewModel.trips.count)
  }
  
  
  func refreshTripData(tripID: String){
    self.viewModel.refreshDataForTrip(tripID: tripID)
  }
  
  func getFilteredTrips(partner: TravelPartner) -> [Trip]{
    print("in getFilteredTrips")
    print(self.viewModel.trips.filter { $0.travelPartners.contains(partner.id) })
    return self.viewModel.trips.filter { $0.travelPartners.contains(partner.id) }
  }
  
  var body: some View {
    NavigationView {
      VStack {
        VStack {
          ZStack {
            VStack {
              Image("trip_1")
                .resizable()
                .frame(height: 150)
            }
            
            HStack {
              Image("person_1")
                .resizable()
                .clipShape(Circle())
                .scaledToFit()
                .frame(height: 100)
              VStack(alignment: .leading) {
                Text("Jane Doe")
                  .font(.title)
                  .fontWeight(.bold)
                  .foregroundColor(.white)
                Text(String(self.viewModel.trips.count) + " trips total")
                  .foregroundColor(.white)
              }
              Spacer()
            }.frame(alignment: .leading)
          }.frame(height: 150)
        }
        
        
        VStack(alignment: .leading) {
          HStack {
            Text("Travel Partners")
              .font(.title)
              .fontWeight(.bold)
            Spacer()
            Button(action: {}){
              Text("Add Partner")
            }.font(.caption)
              .padding(5)
              .padding(.leading, 15)
              .padding(.trailing, 15)
              .background(Color(.sRGB, red: 200/255, green: 200/255, blue: 200/255, opacity: 0.3))
              .clipShape(Capsule())
          }.padding(.leading, 20)
          .padding(.trailing, 20)
          
          List{
            ForEach(travelPartners.travelPartners){partner in
              NavigationLink(destination: FilteredTripListView(trips: self.getFilteredTrips(partner: partner), numbers: self.viewModel.numbers, parent: TripView(), partnerName: partner.firstName)) {
                HStack{
                  ProfileImageCached(urlString: partner.profilePicture)
                  Text(partner.firstName+" "+partner.lastName)
                }
              }
            }
          }
          .navigationBarTitle("")
          .navigationBarHidden(true)
        }
      } // VStack
      .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
    } // Navigation View
    .onAppear(perform: self.refresh)
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView()
  }
}


//        VStack {
//          Text("My Travel Partners")
//            .font(.title)
//            .fontWeight(.bold)
//
//          List {
//            ForEach(users) { user in
//              NavigationLink(destination: ProfileView(users: self.users)) {
//
//                // Cover Photo
//                Image(user.profilePicture)
//                  .resizable()
//                  .scaledToFill()
//                  .frame(width: 120, height: 120)
//                  .clipped()
//                  .cornerRadius(10)
//              }
//            }
//          }
//
//
//        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.topLeading)
//        .padding(20)
