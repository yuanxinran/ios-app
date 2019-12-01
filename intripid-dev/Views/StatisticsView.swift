//
//  StatisticsView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/28/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

struct StatisticsView: View {
  @ObservedObject private var viewModel : TripViewModel
  
  init(){
    print("in init")
    self.viewModel = TripViewModel(userID: currentUserDoc)
  }
  
  func refresh(){
    self.viewModel.fetchData()
    print("[Statistics]")
    print(self.viewModel.trips)
    print(self.viewModel.trips.count)
  }
  
  func refreshTripData(tripID: String){
    self.viewModel.refreshDataForTrip(tripID: tripID)
  }
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Text("My Footsteps")
          .font(.title)
          .fontWeight(.bold)
        //        MapViewControllerWrapper(trips: self.viewModel.trips)
        //          .frame(height: 300)
        
        HStack {
          VStack {
            Text("Trips")
              .font(.headline)
            ZStack {
              Circle()
                .fill(Color.yellow)
              Text(String(self.viewModel.trips.count))
            }
          }
          VStack {
            Text("Photos")
              .font(.headline)
            ZStack {
              Circle()
                .fill(Color.yellow)
              Text(String(self.viewModel.trips.reduce(0) { $0 + $1.photoNum }))
            }
          }
          VStack {
            Text("Journals")
              .font(.headline)
            ZStack {
              Circle()
                .fill(Color.yellow)
              Text(String(self.viewModel.trips.reduce(0) { $0 + $1.journalNum }))
            }
          }
        }
        .frame(height: 120)
        .padding(30)
        
        Text("Percentages")
          .font(.title)
          .fontWeight(.bold)
        
        HStack {
          ZStack {
            Rectangle()
              .fill(Color.yellow)
              .cornerRadius(20)
            VStack(alignment: .leading) {
              Text("42%")
                .font(.subheadline)
              Text("Continents")
                .font(.callout)
                .fontWeight(.bold)
            }
          }
          
          ZStack {
            Rectangle()
              .fill(Color.yellow)
              .cornerRadius(20)
            VStack(alignment: .leading) {
              Text("42%")
                .font(.subheadline)
              Text("Countries")
                .font(.callout)
                .fontWeight(.bold)
            }
          }
        }
        .frame(height: 100)
      }
    }.onAppear(perform: self.refresh)
  }
}

struct StatisticsView_Previews: PreviewProvider {
  static var previews: some View {
    StatisticsView()
  }
}
