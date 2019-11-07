//
//  TripDetailTestView.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/6/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import SwiftUI


struct TripDetailTestView: View {
  var tripID: String
  @ObservedObject private var viewModel : TripDetailViewModel
  //  @EnvironmentObject var settings: UserSettings
  
  init(tripID: String){
    print("init detail page")
    self.tripID = tripID
    self.viewModel = TripDetailViewModel(tripID: tripID)
    
  }
  
  
  func refresh() {
    self.viewModel.fetchData()
    print("refresh called")
  }
  
  var body : some View{
    
    ZStack {
      if viewModel.trip.count != 0 {
        ScrollView {
          VStack (alignment: .leading){
            
            TripCoverView(trip: viewModel.trip[0], parent: self)
            
            //TODO: Integrate Map View!
            Text("Map")
              .padding(.leading)
              .font(.headline)
            //TripMapView(viewModel: TripMapViewModel)
            MapViewControllerWrapper().frame(height: 150)
            
            
            Text("Entries")
              .padding(.leading)
              .font(.headline)
            TripPhotosView(photos: viewModel.trip[0].photos)
            Spacer()
          }
        }.edgesIgnoringSafeArea(.all)
        
        VStack (alignment: .center) {
          Spacer()
        }
        
      } else {
        Text("Loading your trip....")
      }
      
    }.onAppear(perform: self.refresh)
    
  }
}





