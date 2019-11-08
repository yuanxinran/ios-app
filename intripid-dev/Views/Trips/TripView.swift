//
//  TripView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/28/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

struct TripView: View {
  @State private var viewMode = ["List", "Map"]
  @State private var selectedViewMode = 0
  @ObservedObject private var viewModel : TripViewModel
//  @EnvironmentObject var settings: UserSettings
  
  init(){
    self.viewModel = TripViewModel(userID: currentUserDoc)
  }
  
  func refresh(){
    self.viewModel.fetchData()
  }
  
  
  func refreshTripData(tripID: String){
    self.viewModel.refreshDataForTrip(tripID: tripID)
  }
    
  var body: some View {
      NavigationView{
        VStack {
          //Segmented Control
          TripViewModePicker(viewMode: $viewMode, selectedViewMode: $selectedViewMode)
          
          if selectedViewMode == 0 {
            TripListView(trips: self.viewModel.trips, numbers: self.viewModel.numbers, parent: self)
          } else {
            MapViewControllerWrapper()
          }
          
          }.navigationBarTitle(Text("All Trips"), displayMode: .automatic).navigationBarItems(trailing:
          NavigationLink("Create",destination: CreateView()))
      }.onAppear(perform: self.refresh).edgesIgnoringSafeArea(.all)
  }
}

//struct TripView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripView()
//    }
//}
