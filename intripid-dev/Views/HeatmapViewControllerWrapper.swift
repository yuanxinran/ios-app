//
//  HeatmapViewControllerWrapper.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 12/4/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI
import UIKit
import GoogleMaps

struct HeatmapViewControllerWrapper: UIViewControllerRepresentable {
  typealias UIViewControllerType = HeatmapViewController
  var trips: [Trip]
  var parent: TripView

    func makeUIViewController(context: UIViewControllerRepresentableContext<HeatmapViewControllerWrapper>) -> HeatmapViewControllerWrapper.UIViewControllerType {
      print("In HeatmapViewController")
      return HeatmapViewController(trips: trips, vparent: self.parent)
    }

    func updateUIViewController(_ uiViewController: HeatmapViewControllerWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<HeatmapViewControllerWrapper>) {
    }
}
