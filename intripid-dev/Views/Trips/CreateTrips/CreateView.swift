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


struct ListProfilePicture : View {
    let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/intripid-256611.appspot.com/o/profileImages%2Fanna.png?alt=media&token=11ed87aa-958e-4de0-a74e-ea7e9420d5dd")!

    var body: some View {
      

      RemoteImage(url: url, errorView: { error in
          Text(error.localizedDescription)
      }, imageView: { image in
          image
          .resizable()
          .scaledToFill()
          .frame(width: 30, height: 30)
          .clipShape(Circle())
            .offset(CGSize(width: 20, height: 0)).padding(.trailing, 20)
      }, loadingView: {
          Image("person_2")
          .resizable()
          .scaledToFill()
          .frame(width: 30, height: 30)
          .clipShape(Circle())
            .offset(CGSize(width: 20, height: 0)).padding(.trailing, 20)
      })
         
    }
}

struct PartnerCell: View{
  
  private let person: TravelPartner
  private let selected: Bool
  
  init(person: TravelPartner, selected: Bool) {
      self.person = person
      self.selected = selected
  }
  
  var body: some View{
    HStack {
      ListProfilePicture()
      Text(person.firstName+" "+person.lastName)
      Spacer()

      Image(systemName: selected ? "checkmark.circle.fill" : "checkmark.circle")
          .imageScale(.large)
    }
  }
}




struct CreateView: View {

  @State private var selectedPartners = [String]()
  @ObservedObject var allPartners = partnerObserver()
  @State private var title = ""
  var body: some View {
    
    VStack{
        VStack(alignment: .leading, spacing: 20.0){
          Text("Create A Trip").font(.title).fontWeight(.bold)
          VStack(alignment: .leading, spacing: 8.0){
            Text("Trip Title")
            .font(.headline)
            TextField("Trip Title", text: $title).textFieldStyle(PlainTextFieldStyle())
          }
          
          VStack(alignment: .leading, spacing: 12.0){
            Text("Who are you traveling with?")
            
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
            NavigationLink(destination: NewTripAddPhotos()){
              GreenButton("Next")
            }
          }
        }
        Spacer()
    }.padding(.leading,20).padding(.trailing,20)
       
           
}
}


struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
      CreateView()
    }
}



