//
//  TripDetail.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/5/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation

import SwiftUI

struct TripDetailView: View {
  @ObservedObject private var viewModel : TripViewModel
  @EnvironmentObject var settings: UserSettings
  
  init(){
    print("init")
    self.viewModel = TripViewModel(userID: currentUserDoc)
  }
  var body: some View {
    VStack{
      Text("Trips: \(viewModel.trips.count)")
      ForEach((0 ..< self.viewModel.trips.count), id: \.self) { index in
        Text("\(self.viewModel.trips[index].title)") 
      }
    }.onAppear(perform: viewModel.fetchData)
    
  }
  
}


struct TripDetailView_Previews: PreviewProvider {
    static var previews: some View {
      TripDetailView()
    }
}
