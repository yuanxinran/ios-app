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

  
  let trips: [Trip]
    
  var body: some View {
      NavigationView{
        VStack {
          //Segmented Control
          TripViewModePicker(viewMode: $viewMode, selectedViewMode: $selectedViewMode)
          
          if selectedViewMode == 0 {
            TripListView(trips: trips)
          } else {
            TripMapView()
          }
          
          }.navigationBarTitle(Text("All Trips"), displayMode: .automatic).navigationBarItems(trailing:
          NavigationLink("Create",destination: CreateView()))
    }.edgesIgnoringSafeArea(.all)
  }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView(trips: tripsData)
    }
}
