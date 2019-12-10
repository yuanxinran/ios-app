//
//  StatisticsView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/28/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct StatisticsView: View {
  @ObservedObject private var viewModel : TripViewModel
  
  init(){
    print("in init")
    self.viewModel = TripViewModel(userID: currentUserDoc)
  }
  
  func refresh(){
    self.viewModel.fetchData()
  }
  
  
  var body: some View {
    NavigationView{
        HeatmapViewControllerWrapper(trips: self.viewModel.trips, parent: TripView())
        .onAppear(perform: self.refresh)
        .overlay(
            HStack {
              StatisticNumberView(header: "Trips", number: self.viewModel.trips.count)
              StatisticNumberView(header: "Photos", number: self.viewModel.trips.reduce(0) { $0 + $1.photoNum })
              StatisticNumberView(header: "Journals", number: self.viewModel.trips.reduce(0) { $0 + $1.journalNum })
            }
            .frame(height: 150)
            .padding(20),

            alignment: .top
        )
      .navigationBarTitle(Text("My Footsteps"), displayMode: .automatic)
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
  }
}

struct StatisticNumberView: View {
  var header: String
  var number: Int
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10, style: .continuous)
        .fill(
          LinearGradient(
            gradient: Gradient(
              colors: [Color(.sRGB, red: 180/255.0, green: 180/255.0, blue: 180/255.0, opacity: 0.5),
                       Color(.sRGB, red: 180/255.0, green: 180/255.0, blue: 180/255.0, opacity: 0.1)]),
            startPoint: .top,
            endPoint: .bottom
          )
      )
      
      VStack {
        Text(self.header)
          .font(.headline)
        Text(String(self.number))
          .padding(.top, 20)
          .font(.headline)
      }
    }
//    VStack {
//      Text(self.header)
//        .font(.headline)
//      ZStack {
//        Circle()
//          .fill(Color.yellow)
//        Text(String(self.number))
//      }
//    }
  }
}
