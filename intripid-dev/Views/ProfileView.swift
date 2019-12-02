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
  
  var body: some View {
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
              Text("Hello!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
              Text("42 trips total")
                .foregroundColor(.white)
            }
            Spacer()
          }.frame(alignment: .leading)
        }.frame(height: 150)
      }
      
               
      VStack(alignment: .leading) {
        Text("Travel Partners")
          .font(.headline)
          .fontWeight(.bold)
          .padding(10)
        NavigationView {
          List{
            ForEach(travelPartners.travelPartners){partner in
              NavigationLink(destination: TripListView(trips: self.viewModel.trips.filter { !$0.travelPartners.isEmpty }, numbers: self.viewModel.numbers, parent: TripView())) {
                HStack{
                  ProfileImageCached(urlString: partner.profilePicture)
                  Text(partner.firstName+" "+partner.lastName)
                }
              }
            }
          }.navigationBarTitle("")
          .navigationBarHidden(true)
          .navigationBarItems(trailing: NavigationLink("Add Partner",destination: CreateView()))
        }.onAppear(perform: self.refresh).edgesIgnoringSafeArea(.all)
      }
    }
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
