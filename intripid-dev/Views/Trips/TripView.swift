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
  
    
  var body: some View {
      NavigationView{
        VStack {
          //Segmented Control
          TripViewModePicker(viewMode: $viewMode, selectedViewMode: $selectedViewMode)
          
          if selectedViewMode == 0 {
            TripListView(trips: self.viewModel.trips)
          } else {
            MapViewControllerWrapper(trips: self.viewModel.trips)
          }
          
          }.navigationBarTitle(Text("All Trips"), displayMode: .automatic).navigationBarItems(trailing:
          NavigationLink("Create",destination: CreateView()))
        }.onAppear(perform: viewModel.fetchData)
        .edgesIgnoringSafeArea(.all)
  }
}

//struct TripView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripView()
//    }
//}
