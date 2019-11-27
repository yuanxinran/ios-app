//
//  ImageLoader.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/2/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
//import FirebaseStorage

struct URLImage: View {
  
  @ObservedObject private var imageLoader = ImageLoader()
  
  var placeholder: Image
  
  init(url: String, placeholder: Image = Image("placeholder")) {
    self.placeholder = placeholder
    self.imageLoader.load(url: url)
  }
  
  var body: some View {
    if let uiImage = self.imageLoader.downloadedImage {
      return Image(uiImage: uiImage)
//      return Image("portrait")
        .resizable()
        .aspectRatio(uiImage.size.width/uiImage.size.height, contentMode: .fit)
//        .scaledToFit()
//        .frame(width: UIScreen.main.bounds.width/3)
//        .frame(minWidth:0, idealWidth: UIScreen.main.bounds.width/3, maxWidth: .infinity, minHeight:0, maxHeight:.infinity)
        .clipped()
        .cornerRadius(5)
    } else {
      return placeholder
        .resizable()
        .aspectRatio(contentMode: .fit)
//        .scaledToFit()
//        .frame(width: UIScreen.main.bounds.width/3)
//        .frame(minWidth:0, idealWidth: UIScreen.main.bounds.width/3, maxWidth: .infinity, minHeight:0, maxHeight:.infinity)
        .clipped()
        .cornerRadius(5)
    }
  }
  
}

class ImageLoader: ObservableObject {
  @Published var downloadedImage: UIImage?
  
  
  func load(url: String) {
    
    guard let imageURL = URL(string: url) else {
      fatalError("ImageURL \(url) is not correct!")
    }
    
    URLSession.shared.dataTask(with: imageURL) { data, response, error in
      
      guard let data = data, error == nil else {
        return
      }
      
      DispatchQueue.main.async {
        self.downloadedImage = UIImage(data: data)
      }

    }.resume()
    
  }
  
  
}

//let placeholder = UIImage(named: "person_4")!
//
//struct FirebaseImage : View {
//    init(id: String) {
//      self.imageLoader = Loader(id)
//      print(self.imageLoader.data ?? "bad")
//    }
//
//    @ObservedObject var imageLoader : Loader
//
//    var image: UIImage? {
//        imageLoader.data.flatMap(UIImage.init)
//    }
//
//    var body: some View {
//      Image(uiImage: imageLoader.data.flatMap(UIImage.init) ?? placeholder  )
//          .resizable()
//          .scaledToFill()
//          .frame(width: 70, height: 70)
//          .clipped()
//          .cornerRadius(10)
//    }
//}
//
//final class Loader : ObservableObject {
//  @Published var data : Data?
//
//  init(_ id: String){
//      // the path to the image
//    let url = "\(id)"
//    let storage = Storage.storage()
//    let ref = storage.reference().child(url)
//    ref.getData(maxSize: 1 * 1204 * 1200) { data, error in
//      if let error = error {
//          print("\(error)")
//      }
//      self.data = data
//
//
//      }
//  }
//}
