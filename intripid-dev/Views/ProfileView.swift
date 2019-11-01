//
//  ProfileView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/28/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
  let users: [User]
  
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
              Text("Lucy Lu")
                .font(.title)
                .fontWeight(.bold)
              Text("4 trips total")
            }
          }.frame(height: 280)
        }
        
        VStack {
          Text("My Travel Partners")
            .font(.title)
            .fontWeight(.bold)
          
          List {
            ForEach(users) { user in
              NavigationLink(destination: ProfileView(users: self.users)) {
                
                // Cover Photo
                Image(user.profilePicture)
                  .resizable()
                  .scaledToFill()
                  .frame(width: 120, height: 120)
                  .clipped()
                  .cornerRadius(10)
              }
            }
          }
          
          
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.topLeading)
        .padding(20)
      }.edgesIgnoringSafeArea(.all)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
      ProfileView(users: usersData)
    }
}
