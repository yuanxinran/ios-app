//
//  MapDetailViewControllerWrapper.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 11/7/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI
import UIKit
import GoogleMaps

struct MapDetailViewControllerWrapper: UIViewControllerRepresentable {
  typealias UIViewControllerType = MapDetailViewController
  var trip: TripDetail

    func makeUIViewController(context: UIViewControllerRepresentableContext<MapDetailViewControllerWrapper>) -> MapDetailViewControllerWrapper.UIViewControllerType {
      return MapDetailViewController(trip: trip)
    }

    func updateUIViewController(_ uiViewController: MapDetailViewControllerWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<MapDetailViewControllerWrapper>) {
    }
}

