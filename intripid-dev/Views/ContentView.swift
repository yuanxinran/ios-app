//
//  ContentView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/27/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  
  var body: some View {
    // TODO: somehow remove the tab view when clicked on specific trip
    TabView {
      TripView(trips: tripsData)
          .tabItem {
            VStack {
              Image(systemName: "1.circle")
              Text("Trips")
            }
        }.tag(1)
        
        StatisticsView()
          .tabItem {
            VStack {
              Image(systemName: "2.circle")
              Text("Statistics")
            }
        }.tag(2)
      
      ProfileView(users: usersData)
          .tabItem {
            VStack {
              Image(systemName: "3.circle")
              Text("Profile")
            }
        }.tag(3)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
