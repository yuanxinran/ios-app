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

/// Point of Interest Item which implements the GMUClusterItem protocol.
class POIItem: NSObject, GMUClusterItem {
  var position: CLLocationCoordinate2D
  var name: String!

  init(position: CLLocationCoordinate2D, name: String) {
    self.position = position
    self.name = name
  }
}

class MapViewController: UIViewController, GMSMapViewDelegate, GMUClusterManagerDelegate {
  
  var trips: [Trip]
  var vparent: TripView
  private var locations: [LocationMarker]
  private var clusterManager: GMUClusterManager!
  let kMapStyle = """
  [{"elementType":"geometry","stylers":[{"color":"#ebe3cd"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#523735"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f1e6"}]},{"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#c9b2a6"}]},{"featureType":"administrative.land_parcel","elementType":"geometry.stroke","stylers":[{"color":"#dcd2be"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#ae9e90"}]},{"featureType":"landscape.natural","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#93817c"}]},{"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"color":"#a5b076"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#447530"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#f5f1e6"}]},{"featureType":"road.arterial","stylers":[{"visibility":"off"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#fdfcf8"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#f8c967"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#e9bc62"}]},{"featureType":"road.highway","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#e98d58"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry.stroke","stylers":[{"color":"#db8555"}]},{"featureType":"road.local","stylers":[{"visibility":"off"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#806b63"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"transit.line","elementType":"labels.text.fill","stylers":[{"color":"#8f7d77"}]},{"featureType":"transit.line","elementType":"labels.text.stroke","stylers":[{"color":"#ebe3cd"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#b9d3c2"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#92998d"}]}]
  """
  let kMapStyleDay = """
   [{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#575757"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e0e0e0"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#a0a0a0"}]},{"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#ffffff"}]}]
   """
   let kMapStyleNight = """
   [{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]
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
    let camera = GMSCameraPosition.camera(withLatitude: locations.first?.latitude ?? 42.0, longitude: locations.first?.longitude ?? 42.0, zoom: 1)
    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    // MAP STYLING
    do {
      mapView.mapStyle = try GMSMapStyle(jsonString: self.traitCollection.userInterfaceStyle == .dark ? kMapStyleNight : kMapStyleDay)
    } catch {
      NSLog("One or more of the map styles failed to load. \(error)")
    }
    
    mapView.delegate = self
    self.view = mapView
    
    // PLACE MARKERS
//    for location in locations {
//      let position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
//      let marker = GMSMarker(position: position)
//      marker.map = mapView
//    }
    
    // Set up the cluster manager with the supplied icon generator and
     // renderer.
     let iconGenerator = GMUDefaultClusterIconGenerator()
     let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
     let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                 clusterIconGenerator: iconGenerator)
     clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                                       renderer: renderer)

     // Generate and add random items to the cluster manager.
     generateClusterItems()

     // Call cluster() after items have been added to perform the clustering
     // and rendering on map.
     clusterManager.cluster()
    
    // Register self to listen to both GMUClusterManagerDelegate and
    // GMSMapViewDelegate events.
     clusterManager.setDelegate(self, mapDelegate: self)
  }
  
  /// Randomly generates cluster items within some extent of the camera and
  /// adds them to the cluster manager.
  private func generateClusterItems() {
    for location in locations {
      let lat = location.latitude
      let lng = location.longitude
      let name = "Item \(location.tripID)"
      let item =
          POIItem(position: CLLocationCoordinate2DMake(lat, lng), name: name)
      clusterManager.add(item)
    }
  }
  
//  private func clusterManager(clusterManager: GMUClusterManager, didTapCluster cluster: GMUCluster) {
//    let newCamera = GMSCameraPosition.camera(withLatitude: cluster.position.latitude, longitude: cluster.position.longitude, zoom: mapView.camera.zoom + 1)
//    let update = GMSCameraUpdate.setCamera(newCamera)
//    mapView.moveCamera(update)
//  }
  
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    
    if let poiItem = marker.userData as? POIItem {
        print("Did tap marker for cluster item \(String(describing: poiItem.name))")
      } else {
        print("Did tap a normal marker")
        let locationIndex = locations.indices.filter {locations[$0].latitude == marker.position.latitude && locations[$0].longitude == marker.position.longitude}.first!
        let nextVC = UIHostingController(rootView: TripDetailView(tripID: locations[locationIndex].tripID, parent: self.vparent))
        navigationController?.pushViewController(nextVC, animated: true)
        print(nextVC)
        
        print("Marker tapped")
        return true
      }
      return false
    }
}
