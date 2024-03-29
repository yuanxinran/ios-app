//
//  CreateView.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/2/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import SwiftUI
import RemoteImage


struct PartnerCell: View{
  
  private let person: TravelPartner
  private let selected: Bool
  
  init(person: TravelPartner, selected: Bool) {
    self.person = person
    self.selected = selected
  }
  
  var body: some View{
    HStack {
      CreateTripsProfileImageCached(urlString: person.profilePicture)
      Text(person.firstName+" "+person.lastName)
      Spacer()
      
      Image(systemName: selected ? "checkmark.circle.fill" : "circle")
        .imageScale(.large)
    }
  }
}




struct CreateView: View {
  
  @State private var selectedPartners = [String]()
  @ObservedObject var allPartners = TravelPartnerViewModel()
  @State private var title = ""
  
  
  
  var body: some View {
    
    VStack{
      VStack(alignment: .leading, spacing: 20.0){
        Text("Create A Trip").font(.title).fontWeight(.bold).padding(.bottom, 10)
        VStack(alignment: .leading, spacing: 8.0){
          HStack{
            Text("Trip Title").font(.headline)
            Text("*").font(.headline).foregroundColor(Color(.sRGB, red: 52.0/255.0, green: 121/255.0, blue: 137.0/255.0, opacity: 1.0))
          }
          
          TextField("Trip Title", text: $title).textFieldStyle(PlainTextFieldStyle())
        }
        
        VStack(alignment: .leading, spacing: 12.0){
          Text("Who are you traveling with?").font(.headline)
          
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
//          NavigationLink(destination: TripDetail()){
//            GreenButton("Next")
//          }
          if title == ""{
            GreyedButton("Next")
          } else {
            NavigationLink(destination: NewTripAddPhotos(title: self.title, travelPartners: self.selectedPartners)){
              GreenButton("Next")
            }
          }
          
        }
      }.padding(.bottom, 30)

      
    }.padding(.leading, UIScreen.main.bounds.width * 0.05).padding(.trailing,UIScreen.main.bounds.width * 0.05)
    
    
  }
}


struct CreateView_Previews: PreviewProvider {
  static var previews: some View {
    CreateView()
  }
}



