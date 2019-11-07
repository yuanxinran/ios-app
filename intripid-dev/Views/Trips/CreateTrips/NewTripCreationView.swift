//
//  NewTripCreationView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 11/7/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

struct NewTripCreationView: View {
  @ObservedObject private var viewModel:TripViewModel
  
  init(){
    print("[NewTripCreationView] init")
    self.viewModel = TripViewModel(userID: "mD6zAy0T0oh9qAYajiyE")
    self.viewModel.fetchData()
    print(self.viewModel.trips)
  }
  
    var body: some View {
//      VStack {
//        Spacer()
//        Text("Your trip has been successfully created! 🌻")
        ToRootViewControllerWrapper()//.frame(height: 50)
//      }
    }
}

//struct NewTripCreationView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewTripCreationView()
//    }
//}
