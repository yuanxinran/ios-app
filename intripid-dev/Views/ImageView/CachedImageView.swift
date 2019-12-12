//
//  CachedImageView.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/6/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import SwiftUI
import RemoteImage

let ImagePlaceholder = URL(string: "https://firebasestorage.googleapis.com/v0/b/intripid-256611.appspot.com/o/placeholder.jpg?alt=media&token=b0cb781b-c2b6-45b9-bbe4-d03429f6b6d2")!

struct ProfileImageCached : View {
  var url : URL
  init(urlString: String){
    self.url = URL(string: urlString)!
  }
  
  var body: some View {
    
    RemoteImage(url: url, errorView: { error in
      Image("person_2")
        .resizable()
        .scaledToFill()
        .frame(width: 70, height: 70)
        .clipped()
        .cornerRadius(10)
    }, imageView: { image in
      image
        .resizable()
        .scaledToFill()
        .frame(width: 70, height: 70)
        .clipped()
        .cornerRadius(10)
    }, loadingView: {
      Image("person_2")
        .resizable()
        .scaledToFill()
        .frame(width: 70, height: 70)
        .clipped()
        .cornerRadius(10)
    })
    
  }
}



struct CreateTripsProfileImageCached : View {
  var url : URL
  init(urlString: String){
    self.url = URL(string: urlString) ?? ImagePlaceholder
  }
  
  var body: some View {
    
    RemoteImage(url: url, errorView: { error in
      Image("person_2")
        .resizable()
        .scaledToFill()
        .frame(width: 30, height: 30)
        .clipShape(Circle())
    }, imageView: { image in
      image
        .resizable()
        .scaledToFill()
        .frame(width: 30, height: 30)
        .clipShape(Circle())
    }, loadingView: {
      Image("person_2")
        .resizable()
        .scaledToFill()
        .frame(width: 30, height: 30)
        .clipShape(Circle())
    })
    
  }
}

struct CoverImageCached : View {
  var url : URL
  init(urlString: String){
    self.url = URL(string: urlString) ?? ImagePlaceholder
  }
  var body: some View {
    RemoteImage(url: url, errorView: { error in
      Image("placeholder")
        .resizable()
        .scaledToFill()
        .frame(width: 120, height: 120)
        .clipped()
        .cornerRadius(10)
    }, imageView: { image in
      image
        .resizable()
        .scaledToFill()
        .frame(width: 120, height: 120)
        .clipped()
        .cornerRadius(10)
    }, loadingView: {
      Image("placeholder")
        .resizable()
        .scaledToFill()
        .frame(width: 120, height: 120)
        .clipped()
        .cornerRadius(10)
    })
    
  }
}


struct CoverImageDetailCached : View {
  var url : URL
  init(urlString: String){
    self.url = URL(string: urlString) ?? ImagePlaceholder
  }
  var body: some View {
    RemoteImage(url: url, errorView: { error in
      Image("placeholder")
        .resizable()
        .scaledToFill()
        .frame(height: CGFloat(250))
        .clipped()
    }, imageView: { image in
      image
        .resizable()
        .scaledToFill()
        .frame(height: CGFloat(250))
        .clipped()
    }, loadingView: {
      Image("placeholder")
        .resizable()
        .scaledToFill()
        .frame(height: CGFloat(250))
        .clipped()
    })
    
  }
}

