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
  let kMapStyle = """
  [{"elementType":"geometry","stylers":[{"color":"#ebe3cd"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#523735"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f1e6"}]},{"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#c9b2a6"}]},{"featureType":"administrative.land_parcel","elementType":"geometry.stroke","stylers":[{"color":"#dcd2be"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#ae9e90"}]},{"featureType":"landscape.natural","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#93817c"}]},{"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"color":"#a5b076"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#447530"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#f5f1e6"}]},{"featureType":"road.arterial","stylers":[{"visibility":"off"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#fdfcf8"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#f8c967"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#e9bc62"}]},{"featureType":"road.highway","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#e98d58"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry.stroke","stylers":[{"color":"#db8555"}]},{"featureType":"road.local","stylers":[{"visibility":"off"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#806b63"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"transit.line","elementType":"labels.text.fill","stylers":[{"color":"#8f7d77"}]},{"featureType":"transit.line","elementType":"labels.text.stroke","stylers":[{"color":"#ebe3cd"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#b9d3c2"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#92998d"}]}]
  """
  
  init(trips: [Trip], vparent: TripView) {
    self.trips = trips
    self.vparent = vparent
    print("[HeatmapViewController] trips", trips)
    let testLocations = trips.map{ LocationMarker(tripID: $0.id, latitude: $0.coverImage?.photoLocation?.latitude ??  42.0, longitude: $0.coverImage?.photoLocation?.longitude ?? 42.0) }
    self.locations = testLocations
    print("[HeatmapViewController] testLocations", testLocations)
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
      mapView.mapStyle = try GMSMapStyle(jsonString: kMapStyle)
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
    let nextVC = UIHostingController(rootView: TripDetailTestView(tripID: locations[locationIndex].tripID, parent: self.vparent))
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
