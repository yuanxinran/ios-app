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
  @State private var shown = true
  @State private var showActionSheet = false
  @State private var deleteIndex = 0
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  var entries: [Entry]
  var idx: Int
  var tripID: String
  private var viewModel : EditTripViewModel
  private var parent : TripDetailView
  
  init(entries:[Entry], idx: Int, tripID: String, parent: TripDetailView) {
    self.entries = entries
    self.idx = idx
    self.viewModel = EditTripViewModel()
    self.tripID = tripID
    self.parent = parent
  }
  
  func onDismiss(){
    self.presentationMode.wrappedValue.dismiss()
    self.parent.refresh()
  }
  
  func deleteEntry(){
    print("index: \(self.deleteIndex)")
    self.presentationMode.wrappedValue.dismiss()
    let entry = self.entries[self.deleteIndex]
    self.shown = false
    if entry.type == "photo"{
      viewModel.deletePhoto(tripID: self.tripID, photoID: entries[deleteIndex].getDocID()){
          (result: String) in
        self.parent.refresh()

      }
    } else {
      viewModel.deleteJournal(tripID: self.tripID, journalID: entries[deleteIndex].getDocID()){
          (result: String) in
        self.parent.refresh()
      }
    }
    
  }
  
  
  
  var body: some View {
    
    // MARK: Loading a scroll view of placeholder images
    VStack{
    GeometryReader { proxy in
      UIScrollViewWrapper {
        HStack{
          if self.shown {
            ForEach(0 ..< self.entries.count) { entryIndex in
              VStack {
                EntryCellDetailed(entry: self.entries[entryIndex])
                  .padding(.leading, 8)
                  .frame(width: proxy.size.width-8)
                
//                VStack {
//
//                    Button(action: {self.deleteEntry(entryIndex)}) {
//                      Text("Delete")
//                    }.font(.caption)
//                      .padding(5)
//                      .padding(.leading, 15)
//                      .padding(.trailing, 15)
//                      .background(Color(.sRGB, red: 200/255, green: 200/255, blue: 200/255, opacity: 0.3))
//                      .clipShape(Capsule())
//
//
//                }.padding(20)
                  VStack {
                      Button("Delete Entry") {
                          self.showActionSheet = true
                          self.deleteIndex = entryIndex
                      }
                  }.actionSheet(isPresented: self.$showActionSheet) {
                      ActionSheet(
                          title: Text("Delete Entry"),
                          message: Text("Are you sure that you want to delete this entry?"),
                          buttons: [
                              .cancel { print(self.showActionSheet) },
                              .destructive(Text("Delete")){self.deleteEntry()}
                          ]
                      )
                  }
                
              }
            }
          }
        }
        .frame(width: proxy.size.width * CGFloat(self.entries.count - self.idx), height: proxy.size.height)
        .offset(x: (-proxy.size.width * 0.5) * CGFloat(self.idx) - 4, y: -20)
      }
    }
    }.navigationBarItems(trailing:
        Button("Delete") {
            print("Delete tapped!")
        }
    )
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
