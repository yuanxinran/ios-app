//
//  Trip.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/28/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation

struct Trip: Identifiable {
  var id = UUID()
  var title: String
  var cover: String
  var startDate: Date
//  var endDate: Date
  var photos: [String] // TODO: fix this
  var latitude: Double
  var longitude: Double
}

// TODO: get the trips from the API
let tripsData = [
  Trip(title: "Florida",
       cover: "trip_1",
       startDate: Date(),
       photos: photosData.shuffled(),
       latitude: 28.4813989,
       longitude: -81.5088355),
  Trip(title: "Hawaii",
       cover: "trip_2",
       startDate: Date(),
       photos: photosData.shuffled(),
       latitude: 21.3281792,
       longitude: -157.8691135),
  Trip(title: "Pittsburgh",
       cover: "trip_1",
       startDate: Date(),
       photos: photosData.shuffled(),
       latitude: 40.431478,
       longitude: -80.0505405),
  Trip(title: "Miami",
       cover: "trip_2",
       startDate: Date(),
       photos: photosData.shuffled(),
       latitude: 25.7825453,
       longitude: -80.2994988)
]

let photosData = ["picture_1", "picture_2", "picture_3", "picture_4", "picture_5", "picture_6", "picture_7", "picture_8", "picture_9", "picture_10", "picture_11", "picture_12", "picture_13", "picture_14", "picture_15", "picture_16", "picture_17", "picture_18", "picture_19", "picture_20"]


