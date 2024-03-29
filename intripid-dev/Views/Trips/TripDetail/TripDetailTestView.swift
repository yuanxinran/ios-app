//
//  TripDetailTestView.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/6/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import SwiftUI


struct TripDetailView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  var tripID: String
  var parent: TripView
  @ObservedObject private var viewModel : TripDetailViewModel
//  @State var journalModalDisplayed = false
  
  
  

  var btnBack : some View { Button(action: {
    self.goBack()
    self.parent.refreshTripData(tripID: self.tripID)
  }) {
    HStack {
      Text("< All Trips")
    }
    }
  }
  //  @EnvironmentObject var settings: UserSettings
  
  init(tripID: String, parent: TripView){
    self.tripID = tripID
    self.viewModel = TripDetailViewModel(tripID: tripID)
    self.parent = parent
  }
  
  func goBack(){
    self.presentationMode.wrappedValue.dismiss()
    
  }
  
  func refresh() {
    self.viewModel.fetchData()
    print("refresh called")
  }
  
  func refreshTripListOnDelete(){
    self.parent.refresh()
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
//            TripMapView(viewModel: TripMapViewModel)
            MapDetailViewControllerWrapper(trip: viewModel.trip[0]).frame(height: 150)
            
            
            Text("Entries")
              .padding(.leading)
              .font(.headline)
            TripEntriesView(entries: viewModel.trip[0].entries, tripID: self.tripID, parent: self)
            Spacer()
          }
        }.edgesIgnoringSafeArea(.all)
        
//        VStack (alignment: .center) {
//          Spacer()
//        }
//        VStack(alignment: .leading){
//
//          GreenButton("Add Journal").onTapGesture {
//                          self.journalModalDisplayed = true
//          }.sheet(isPresented: $journalModalDisplayed) {
//            EditTripAddJournal(tripID: self.tripID, parent: self, startDate: self.viewModel.trip[0].startDate, endDate: self.viewModel.trip[0].endDate, onDismiss: {
//                self.journalModalDisplayed = false
//              })
//          }
//        }
        VStack (alignment: .center) {
          Spacer()
        }
        
      } else {
        ZStack {
          SplashScreen()
          Text("Loading your trip....")
        }
      }
      
    }.onAppear(perform: self.refresh).navigationBarBackButtonHidden(true)
    .navigationBarItems(leading: btnBack)
    
  }
}





