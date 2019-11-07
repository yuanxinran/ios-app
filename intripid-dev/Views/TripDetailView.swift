//
//  TripDetailView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/28/19.
//  Copyright © 2019 zona. All rights reserved.
//
import SwiftUI

struct TripDetailView: View {
  let trip: Trip
//  var tripID: String
//
//  //ACTION SHEET
//  //TODO: Refactor
//  @State var showActionSheet: Bool = false
//
//  var actionSheet: ActionSheet {
//      ActionSheet(title: Text("Action Sheet"), message: Text("Choose Option"), buttons: [
//          .default(Text("Add Photo"), action: {
//              print("Adding Photo!!")
//          }),
//          .default(Text("Add Journal")),
//          .destructive(Text("Cancel"))
//      ])
//  }
//
  var body: some View {
//    Text("Map")
//  }
    ZStack {
      ScrollView {
        VStack (alignment: .leading){

//          TripCoverView(trip: trip)

          //TODO: Integrate Map View!
          Text("Map")
            .padding(.leading)
          .font(.headline)
//          TripMapView(viewModel: TripMapViewModel)
          MapViewControllerWrapper().frame(height: 150)


          Text("Entries")
            .padding(.leading)
            .font(.headline)
//          TripPhotosView(photos: photosData)
          Spacer()
        }
      }.edgesIgnoringSafeArea(.all)

      VStack (alignment: .center) {
        Spacer()
      }
    } //ZStack
  } //view
} //struct
struct TripDetailView_Previews: PreviewProvider {
    static var previews: some View {
      Text("Sorry no preview available lool")
//      TripDetailView(trip: tripsData[0])
    }
}
