//
//  HeatmapViewController.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 12/4/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import GoogleMaps
import GooglePlaces

class HeatmapViewController: UIViewController, GMSMapViewDelegate, GMUClusterManagerDelegate {
  var trips: [Trip]
  var vparent: TripView
  private var locations: [LocationMarker]
  private var heatmapLayer: GMUHeatmapTileLayer!
  
  let kMapStyleDay = """
  [{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#575757"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e0e0e0"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#a0a0a0"}]},{"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#ffffff"}]}]
  """
  let kMapStyleNight = """
  [{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]
  """
  
  init(trips: [Trip], vparent: TripView) {
    self.trips = trips
    self.vparent = vparent
    let testLocations = trips.map{ LocationMarker(tripID: $0.id, latitude: $0.coverImage?.photoLocation?.latitude ??  42.0, longitude: $0.coverImage?.photoLocation?.longitude ?? 42.0) }
    self.locations = testLocations
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    print("[HeatmapViewController] trips", trips)
    super.viewDidLoad()
    
    // MAP SETUP
    //TODO: generate latitude, longitude and zoom dynamically!
    let camera = GMSCameraPosition.camera(withLatitude: locations.first?.latitude ?? 42.0, longitude: locations.first?.longitude ?? 42.0, zoom: 0.2)
    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    // MAP STYLING
    do {
      mapView.mapStyle = try GMSMapStyle(jsonString: self.traitCollection.userInterfaceStyle == .dark ? kMapStyleNight : kMapStyleDay)
    } catch {
      NSLog("One or more of the map styles failed to load. \(error)")
    }
    
    mapView.delegate = self
    self.view = mapView
    
    // HEAT MAP
    heatmapLayer = GMUHeatmapTileLayer()
    heatmapLayer.radius = 50
    addHeatmap()
    heatmapLayer.map = mapView
  }
  
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    let locationIndex = locations.indices.filter {locations[$0].latitude == marker.position.latitude && locations[$0].longitude == marker.position.longitude}.first!
    let nextVC = UIHostingController(rootView: TripDetailView(tripID: locations[locationIndex].tripID, parent: self.vparent))
    navigationController?.pushViewController(nextVC, animated: true)
    print(nextVC)
    
    print("Marker tapped")
    return true
  }
  
  func addHeatmap()  {
    print("Adding Heatmap!.")
    var list = [GMUWeightedLatLng]()
      print("Adding Heatmap! DO DO DO")
      
      for location in locations {
        let lat = location.latitude
        let lng = location.longitude
        let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat , lng ), intensity: 1.0)
        list.append(coords)
      }
    // Add the latlngs to the heatmap layer.
    heatmapLayer.weightedData = list
  }

  
}


//private var heatmapLayer: GMUHeatmapTileLayer!
//...
//override func viewDidLoad() {
//  heatmapLayer = GMUHeatmapTileLayer()
//  heatmapLayer.map = mapView
//}
//...
//func addHeatmap()  {
//  var list = [GMUWeightedLatLng]()
//  do {
//    // Get the data: latitude/longitude positions of police stations.
//    if let path = Bundle.main.url(forResource: "police_stations", withExtension: "json") {
//      let data = try Data(contentsOf: path)
//      let json = try JSONSerialization.jsonObject(with: data, options: [])
//      if let object = json as? [[String: Any]] {
//        for item in object {
//          let lat = item["lat"]
//          let lng = item["lng"]
//          let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat as! CLLocationDegrees, lng as! CLLocationDegrees), intensity: 1.0)
//          list.append(coords)
//        }
//      } else {
//        print("Could not read the JSON.")
//      }
//    }
//  } catch {
//    print(error.localizedDescription)
//  }
//  // Add the latlngs to the heatmap layer.
//  heatmapLayer.weightedData = list
//}
