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
import FirebaseStorage

let placeholder = UIImage(named: "person_4")!

struct FirebaseImage : View {
    init(id: String) {
      self.imageLoader = Loader(id)
      print(self.imageLoader.data ?? "bad")
    }

    @ObservedObject var imageLoader : Loader

    var image: UIImage? {
        imageLoader.data.flatMap(UIImage.init)
    }

    var body: some View {
      Image(uiImage: imageLoader.data.flatMap(UIImage.init) ?? placeholder  )
          .resizable()
          .scaledToFill()
          .frame(width: 70, height: 70)
          .clipped()
          .cornerRadius(10)
    }
}

final class Loader : ObservableObject {
  @Published var data : Data?
  
  init(_ id: String){
      // the path to the image
    let url = "\(id)"
    let storage = Storage.storage()
    let ref = storage.reference().child(url)
    ref.getData(maxSize: 1 * 1204 * 1200) { data, error in
      if let error = error {
          print("\(error)")
      }
      self.data = data

          
      }
  }
}
