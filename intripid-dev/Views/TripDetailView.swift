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

          TripCoverView(trip: trip)

          //TODO: Integrate Map View!
          Text("Map")
            .padding(.leading)
          .font(.headline)
//          TripMapView(viewModel: TripMapViewModel)
          MapViewControllerWrapper().frame(height: 150)


          Text("Entries")
            .padding(.leading)
            .font(.headline)
          TripPhotosView(photos: photosData)
          Spacer()
        }
      }.edgesIgnoringSafeArea(.all)

      VStack (alignment: .center) {
        Spacer()

        //Show Action Sheet
//        Button(action: {
//            self.showActionSheet.toggle()
//        }) {
//          Text("Display Action Sheet")
//            .foregroundColor(.white)
//        }.padding(10)
//        .background(Color(.sRGB, red: 200/255, green: 200/255, blue: 200/255, opacity: 0.7))
//        .clipShape(Capsule())
//        .actionSheet(isPresented: $showActionSheet, content: {
//            self.actionSheet })
//        //Show Adding of Entry
//        NavigationLink(destination: ProfileView(users: usersData)) {
//            Text("Add Entry")
//            .padding(10)
//            .clipShape(Capsule())
//        }
      }
    } //ZStack
  } //view
} //struct
struct TripDetailView_Previews: PreviewProvider {
    static var previews: some View {
      TripDetailView(trip: tripsData[0])
    }
}
