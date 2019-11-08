//
//  MapViewController.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 11/5/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import GoogleMaps

struct LocationMarker {
  var tripID: String
  var latitude: Double
  var longitude: Double
}

class MapViewController: UIViewController, GMSMapViewDelegate {
  
  var trips: [Trip]
  var vparent: TripView
  private var locations: [LocationMarker]
  let kMapStyle = """
  [{"elementType":"geometry","stylers":[{"color":"#ebe3cd"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#523735"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f1e6"}]},{"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#c9b2a6"}]},{"featureType":"administrative.land_parcel","elementType":"geometry.stroke","stylers":[{"color":"#dcd2be"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#ae9e90"}]},{"featureType":"landscape.natural","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#93817c"}]},{"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"color":"#a5b076"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#447530"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#f5f1e6"}]},{"featureType":"road.arterial","stylers":[{"visibility":"off"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#fdfcf8"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#f8c967"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#e9bc62"}]},{"featureType":"road.highway","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#e98d58"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry.stroke","stylers":[{"color":"#db8555"}]},{"featureType":"road.local","stylers":[{"visibility":"off"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#806b63"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"transit.line","elementType":"labels.text.fill","stylers":[{"color":"#8f7d77"}]},{"featureType":"transit.line","elementType":"labels.text.stroke","stylers":[{"color":"#ebe3cd"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#b9d3c2"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#92998d"}]}]
  """
  
  init(trips: [Trip], vparent: TripView) {
    self.trips = trips
    self.vparent = vparent
    print("[MapViewController] trips", trips)
    let testLocations = trips.map{ LocationMarker(tripID: $0.id, latitude: $0.coverImage?.photoLocation?.latitude ??  42.0, longitude: $0.coverImage?.photoLocation?.longitude ?? 42.0) }
    self.locations = testLocations
    print("[MapViewController] testLocations", testLocations)
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // MAP SETUP
    //TODO: generate latitude, longitude and zoom dynamically!
    let camera = GMSCameraPosition.camera(withLatitude: locations[0].latitude, longitude: locations[0].longitude, zoom: 1)
    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    // MAP STYLING
    do {
      mapView.mapStyle = try GMSMapStyle(jsonString: kMapStyle)
    } catch {
      NSLog("One or more of the map styles failed to load. \(error)")
    }
    
    mapView.delegate = self
    self.view = mapView
    
    // PLACE MARKERS
    for location in locations {
      let position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
      let marker = GMSMarker(position: position)
      marker.map = mapView
    }
  }
  
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    let locationIndex = locations.indices.filter {locations[$0].latitude == marker.position.latitude && locations[$0].longitude == marker.position.longitude}.first!
    let nextVC = UIHostingController(rootView: TripDetailTestView(tripID: locations[locationIndex].tripID, parent: self.vparent))
    navigationController?.pushViewController(nextVC, animated: true)
    print(nextVC)
    
    print("Marker tapped")
    return true
  }
  
}
