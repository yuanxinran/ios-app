//
//  MapViewControllerWrapper.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 11/5/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI
import UIKit
import GoogleMaps

struct MapViewControllerWrapper: UIViewControllerRepresentable {
  typealias UIViewControllerType = MapViewController

    func makeUIViewController(context: UIViewControllerRepresentableContext<MapViewControllerWrapper>) -> MapViewControllerWrapper.UIViewControllerType {
        return MapViewController()
    }

    func updateUIViewController(_ uiViewController: MapViewControllerWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<MapViewControllerWrapper>) {
    }
}
