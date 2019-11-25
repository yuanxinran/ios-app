//
//  TripEntryView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 11/24/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

struct TripEntryView: View {
  
  @ObservedObject private var imageLoader = ImageLoader()
  var entries: [Entry]
  var idx: Int
  var url: String
  var urls: [String]
  var uiImage: [UIImage?] = [UIImage?]()
  
  init(entries:[Entry], idx: Int) {
    self.entries = entries
    self.idx = idx
    self.url = entries[idx].photo!.imagePath
    self.urls = entries.map({ $0.photo!.imagePath })
//    self.imageLoader.load(url: url)
//    self.uiImage = urls.map({ url in
//      imageLoader.load(url: url)
//      return imageLoader.downloadedImage
//    })
//    print(self.uiImage)
  }
  
  
  var body: some View {
    // MARK: Loading a scroll view of placeholder images
    UIScrollViewWrapper {
      HStack{
          ForEach(0 ..< self.urls.count) { urlIndex in
//            self.imageLoader.load(url: urls[urlIndex])
            URLImage(url: self.urls[urlIndex])
          }
        }
    }
//        let uiImage = self.imageLoader.downloadedImage {
//                return Image(uiImage: uiImage)
//                .resizable()
//                        .aspectRatio(uiImage.size.width/uiImage.size.height, contentMode: .fit)
//                //        .scaledToFit()
//                        .frame(width: UIScreen.main.bounds.width)
//                //        .frame(minWidth:0, idealWidth: UIScreen.main.bounds.width/3, maxWidth: .infinity, minHeight:0, maxHeight:.infinity)
//                        .clipped()
//                        .cornerRadius(5)
//              }
//      }
//    }
    
    //      MARK: Loading a scroll view of placeholder images
//    UIScrollViewWrapper {
//      HStack{
//        Image("person_1")
//          .resizable()
//          .aspectRatio(contentMode: .fit)
//          .frame(width: UIScreen.main.bounds.width)
//          .clipped()
//          .cornerRadius(5)
//        Image("person_2")
//          .resizable()
//          .aspectRatio(contentMode: .fit)
//          .frame(width: UIScreen.main.bounds.width)
//          .clipped()
//          .cornerRadius(5)
//        Image("person_3")
//          .resizable()
//          .aspectRatio(contentMode: .fit)
//          .frame(width: UIScreen.main.bounds.width)
//          .clipped()
//          .cornerRadius(5)
//      }
//    }
    
    //      MARK: Loading a single Photo
    //      if let uiImage = self.imageLoader.downloadedImage {
    //        return Image(uiImage: uiImage)
    //        .resizable()
    //                .aspectRatio(uiImage.size.width/uiImage.size.height, contentMode: .fit)
    //        //        .scaledToFit()
    //                .frame(width: UIScreen.main.bounds.width)
    //        //        .frame(minWidth:0, idealWidth: UIScreen.main.bounds.width/3, maxWidth: .infinity, minHeight:0, maxHeight:.infinity)
    //                .clipped()
    //                .cornerRadius(5)
    //      }
    //      return Image("person_1")
    //      .resizable()
    //              .aspectRatio(contentMode: .fit)
    //      //        .scaledToFit()
    //              .frame(width: UIScreen.main.bounds.width)
    //      //        .frame(minWidth:0, idealWidth: UIScreen.main.bounds.width/3, maxWidth: .infinity, minHeight:0, maxHeight:.infinity)
    //              .clipped()
    //              .cornerRadius(5)
  }
}

//struct TripEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripEntryView()
//    }
//}

struct UIScrollViewWrapper<Content: View>: UIViewControllerRepresentable {
  
  var content: () -> Content
  
  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }
  
  func makeUIViewController(context: Context) -> UIScrollViewViewController {
    let vc = UIScrollViewViewController()
    vc.hostingController.rootView = AnyView(self.content())
    return vc
  }
  
  func updateUIViewController(_ viewController: UIScrollViewViewController, context: Context) {
    viewController.hostingController.rootView = AnyView(self.content())
  }
}

class UIScrollViewViewController: UIViewController {
  
  lazy var scrollView: UIScrollView = {
    let v = UIScrollView()
    v.isPagingEnabled = true
    return v
  }()
  
  var hostingController: UIHostingController<AnyView> = UIHostingController(rootView: AnyView(EmptyView()))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(self.scrollView)
    self.pinEdges(of: self.scrollView, to: self.view)
    
    self.hostingController.willMove(toParent: self)
    self.scrollView.addSubview(self.hostingController.view)
    self.pinEdges(of: self.hostingController.view, to: self.scrollView)
    self.hostingController.didMove(toParent: self)
    
  }
  
  func pinEdges(of viewA: UIView, to viewB: UIView) {
    viewA.translatesAutoresizingMaskIntoConstraints = false
    viewB.addConstraints([
      viewA.leadingAnchor.constraint(equalTo: viewB.leadingAnchor),
      viewA.trailingAnchor.constraint(equalTo: viewB.trailingAnchor),
      viewA.topAnchor.constraint(equalTo: viewB.topAnchor),
      viewA.bottomAnchor.constraint(equalTo: viewB.bottomAnchor),
    ])
  }
  
}
