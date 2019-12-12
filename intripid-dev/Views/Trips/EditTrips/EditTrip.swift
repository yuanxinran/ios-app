//
//  EditTrip.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/7/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import SwiftUI



struct EditTrip :  View {
  var onDismiss: () -> ()

  @State private var selectedPartners = [String]()
    @State private var showActionSheet = false
  @ObservedObject var allPartners = TravelPartnerViewModel()
  @State private var title = ""
  var viewModel : EditTripViewModel
  var trip: TripDetail
  var parent : TripDetailView



  init(trip: TripDetail, parent: TripDetailView, onDismiss: @escaping () -> ()){
    self.parent = parent
    self.viewModel = EditTripViewModel()
    self.trip = trip
    self.onDismiss = onDismiss
    self.title = trip.title
    self.selectedPartners = trip.travelPartners.map{$0.id}
  }


  func deleteTrip(){
    viewModel.deleteTrip(tripID: self.trip.id){
        (result: String) in
      self.onDismiss()
      self.parent.goBack()
      self.parent.refreshTripListOnDelete()
    }

  }
  
  func updateTrip(){
    self.viewModel.updateTrip(tripID: self.trip.id, title: self.title, travelPartners: self.selectedPartners){
      (result: String) in
      self.onDismiss()
      self.parent.refresh()
    }
  }
  
  func refresh(){
    self.title = self.trip.title
    self.selectedPartners = self.trip.travelPartners.map{$0.id}
  }


  var body: some View {

        VStack{
          VStack {
             HStack{
               Button(action: {self.onDismiss()}) {
                 Text("Close")
               }
               Spacer()
             }.padding(.bottom, 20)
          }
          VStack(alignment: .leading, spacing: 20.0){
            Text("Edit Trip Information").font(.title).fontWeight(.bold).padding(.bottom, 20)
            VStack(alignment: .leading, spacing: 8.0){
              Text("Trip Title")
                .font(.headline)
              TextField("Trip Title", text: $title).textFieldStyle(PlainTextFieldStyle())
            }.padding(.bottom, 10)

            VStack(alignment: .leading, spacing: 12.0){
              Text("Travel Partners")

              VStack(alignment: .leading, spacing: 8.0){
                ForEach(allPartners.travelPartners) {i in
                  PartnerCell(person: i, selected: self.selectedPartners.contains(i.id)).onTapGesture {
                    if self.selectedPartners.contains(i.id){
                      self.selectedPartners = self.selectedPartners.filter{$0 != i.id}
                    } else {
                      self.selectedPartners.append(i.id)
                    }
                  }
                }
              }
            }
          }
          Spacer()
          VStack(alignment: .leading){
            HStack(alignment: .top){
              Spacer()
              
              VStack {
                RedButton("Delete Trip").onTapGesture {
                  self.showActionSheet = true
                }
               }.actionSheet(isPresented: self.$showActionSheet) {
                   ActionSheet(
                       title: Text("Delete Trip"),
                       message: Text("Are you sure that you want to delete this trip"),
                       buttons: [
                           .cancel { print(self.showActionSheet) },
                           .destructive(Text("Delete Trip")){self.deleteTrip()}
                       ]
                   )
               }

              
              GreenButton("Update Trip").onTapGesture {
                self.updateTrip()
              }
            }
          }.padding(.bottom, 50)


        }.onAppear(perform: self.refresh).padding(.leading, UIScreen.main.bounds.width * 0.05).padding(.trailing,UIScreen.main.bounds.width * 0.05).padding(.top,20)
  }



}
