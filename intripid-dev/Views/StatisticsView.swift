//
//  StatisticsView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/28/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

struct StatisticsView: View {
  var body: some View {
    VStack(alignment: .leading) {
      Text("My Footsteps")
        .font(.title)
        .fontWeight(.bold)
      TripMapView()
        .frame(height: 300)
      
      HStack {
        VStack {
          Text("Continents")
            .font(.headline)
          ZStack {
            Circle()
              .fill(Color.yellow)
            Text("42")
          }
        }
        VStack {
          Text("Countries")
            .font(.headline)
          ZStack {
            Circle()
              .fill(Color.yellow)
            Text("42")
          }
        }
        VStack {
          Text("Trips")
            .font(.headline)
          ZStack {
            Circle()
              .fill(Color.yellow)
            Text("42")
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
  }
}

struct StatisticsView_Previews: PreviewProvider {
  static var previews: some View {
    StatisticsView()
  }
}
