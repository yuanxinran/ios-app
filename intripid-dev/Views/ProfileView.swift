//
//  ProfileView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/28/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI
import FirebaseStorage


struct ProfileView: View {
  @ObservedObject var travelPartners = partnerObserver()
  
  var body: some View {
    VStack {
      VStack {
        ZStack {
          VStack {
            Image("trip_1")
              .resizable()
              .frame(height: 150)
            Spacer()
          }
          
          VStack {
            Image("person_1")
              .resizable()
              .clipShape(Circle())
              .scaledToFit()
              .frame(height: 120)
            Text("Hello!")
              .font(.title)
              .fontWeight(.bold)
            Text("42 trips total")
          }
        }.frame(height: 280)
      }
      VStack {
        NavigationView {
          List{
            ForEach(travelPartners.travelPartners){partner in
              NavigationLink(destination: ProfileView()) {
                HStack{
                  FirebaseImage(id: partner.profilePicture)
                  Text(partner.firstName+" "+partner.lastName)
                }
              }
            }
          }.navigationBarTitle("")
          .navigationBarHidden(true)
        }
      }
    }
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView()
  }
}


//        VStack {
//          Text("My Travel Partners")
//            .font(.title)
//            .fontWeight(.bold)
//
//          List {
//            ForEach(users) { user in
//              NavigationLink(destination: ProfileView(users: self.users)) {
//
//                // Cover Photo
//                Image(user.profilePicture)
//                  .resizable()
//                  .scaledToFill()
//                  .frame(width: 120, height: 120)
//                  .clipped()
//                  .cornerRadius(10)
//              }
//            }
//          }
//
//
//        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.topLeading)
//        .padding(20)
