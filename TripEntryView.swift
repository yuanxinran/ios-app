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
  }
  
  var body: some View {
    // MARK: Loading a scroll view of placeholder images
    GeometryReader { proxy in
      UIScrollViewWrapper {
        HStack{
            ForEach(0 ..< self.urls.count) { urlIndex in
//              self.imageLoader.load(url: urls[urlIndex])
              URLImage(url: self.urls[urlIndex])
                .padding(.leading, 8)
                .frame(width: proxy.size.width-8)
            }
        }
        .frame(width: proxy.size.width * CGFloat(self.urls.count - self.idx))
        .offset(x: (-proxy.size.width * 0.5) * CGFloat(self.idx) - 4, y: 20)
//        .position(x: proxy.size.width/2 + proxy.size.width * CGFloat(self.urls.count/2), y: proxy.size.height/2)
      }
    }
  }
}

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
