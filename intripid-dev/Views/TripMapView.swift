//
//  TripMapView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/29/19.
//  Copyright © 2019 zona. All rights reserved.
//

//import SwiftUI

//struct TripMapView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct TripMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripMapView()
//    }
//}

import SwiftUI
import UIKit
import GoogleMaps

let kMapStyle = """
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ebe3cd"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#523735"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f1e6"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#c9b2a6"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#dcd2be"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#ae9e90"
      }
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#93817c"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#a5b076"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#447530"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f1e6"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#fdfcf8"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f8c967"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#e9bc62"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e98d58"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#db8555"
      }
    ]
  },
  {
    "featureType": "road.local",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#806b63"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8f7d77"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#ebe3cd"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#b9d3c2"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#92998d"
      }
    ]
  }
]
"""

struct TripMapView: UIViewRepresentable {
  var trips: [Trip] = tripsData
  //TODO: change count to the number of trips!
//  var markers: [GMSMarker] = [GMSMarker(), GMSMarker(), GMSMarker()]
//  var markers : [GMSMarker] = Array.init(repeating: GMSMarker(), count: 5)
  var markers: [GMSMarker] = Array(0...3).map({ (ignore) -> GMSMarker in
      return GMSMarker()
  })
  
  var marker1 = GMSMarker()
  var marker2 = GMSMarker()
  
  func makeUIView(context: Self.Context) -> GMSMapView {
    let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 10.0)
    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    
    do {
      // Set the map style by passing a valid JSON string.
      mapView.mapStyle = try GMSMapStyle(jsonString: kMapStyle)
    } catch {
      NSLog("One or more of the map styles failed to load. \(error)")
    }
    
    return mapView
  }
  
  func updateUIView(_ mapView: GMSMapView, context: Self.Context) {
    print("updating view")
    // Creates a marker in the center of the map.
    marker1.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
    marker1.title = "Sydney"
    marker1.snippet = "Population: 8,174,100"
    marker1.map = mapView
    
    marker2.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.30)
    marker2.title = "HELLO!"
    marker2.snippet = "Population: 8,174,100"
    marker2.map = mapView
    
    markers[0].position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.25)
    markers[0].title = "Sydney"
    markers[0].snippet = "Population: 8,174,100"
    markers[0].map = mapView
    
    markers[1].position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.275)
    markers[1].title = "WORKS!"
    markers[1].snippet = "Population: 8,174,100"
    markers[1].map = mapView
    
    print(markers[0], markers[1])
  }
  
}

struct TripMapView_Previews: PreviewProvider {
  static var previews: some View {
    TripMapView(trips: tripsData)
  }
}
