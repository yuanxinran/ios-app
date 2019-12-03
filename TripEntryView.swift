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
  
  init(entries:[Entry], idx: Int) {
    self.entries = entries
    self.idx = idx
  }
  
  var body: some View {
    // MARK: Loading a scroll view of placeholder images
    GeometryReader { proxy in
      UIScrollViewWrapper {
        HStack{
            ForEach(0 ..< self.entries.count) { entryIndex in
              VStack {
                EntryCellDetailed(entry: self.entries[entryIndex])
                  .padding(.leading, 8)
                  .frame(width: proxy.size.width-8)
                
                VStack {
                  Button(action: {}) {
                    Text("Delete")
                  }.font(.caption)
                    .padding(5)
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .background(Color(.sRGB, red: 200/255, green: 200/255, blue: 200/255, opacity: 0.3))
                    .clipShape(Capsule())
                }.padding(20)
              }
            }
        }
        .frame(width: proxy.size.width * CGFloat(self.entries.count - self.idx), height: proxy.size.height)
        .offset(x: (-proxy.size.width * 0.5) * CGFloat(self.idx) - 4, y: -20)
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
