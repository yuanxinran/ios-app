//
//  EditTripAddJournal.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/7/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import SwiftUI



struct EditTripAddJournal :  View {
  var onDismiss: () -> ()
  
  private var tripID : String
  private var viewModel : EditTripViewModel
  private var parent : TripDetailView
  private var dates : [NSDate]
  @State private var title : String = ""
  @State private var content : String = ""
  @State private var colorSet : Int = 0
  @State private var selectedDate : Int = 0
  
  let colors = [["1s","1e"], ["2s","2e"],["3s","3e"]]
  
  init(tripID: String, parent: TripDetailView, startDate: NSDate, endDate: NSDate, onDismiss: @escaping () -> ()){
    self.tripID = tripID
    self.viewModel = EditTripViewModel()
    self.onDismiss = onDismiss
    self.parent = parent
    self.dates = Date.dates(from: startDate as Date, to: endDate as Date) as [NSDate]
    UITableView.appearance().backgroundColor = .clear
    UITableViewCell.appearance().backgroundColor = .clear
    UITableView.appearance().separatorStyle = .none
  }
  
  func addJournalToTrip(){
    self.viewModel.addJournalToTrip(title: title, content: content, startColor: colors[colorSet][0], endColor: colors[colorSet][1], dateTime: dates[selectedDate], tripID: self.tripID) { (result: String) in
      print("successfully added journal \(result)")
      self.parent.refresh()
    }
    self.onDismiss()
  }
  
  var body: some View {
    NavigationView {
      VStack{
        
        ZStack {
          Rectangle()
            .fill(LinearGradient(
              gradient: .init(colors: [Color(colors[colorSet][0]), Color(colors[colorSet][1])]),
              startPoint: .init(x: 0.5, y: 0),
              endPoint: .init(x: 0.5, y: 0.6)
            ))
            .cornerRadius(20)

          Form {
            TextField("Heading", text: $title)
              .font(.headline)
            MultilineTextField("Journal", text: $content, onCommit: {print("Final text:")})
              .font(.body)
//              .backgroundColor(.clear)

            Picker(selection: $selectedDate, label: Text("Date")) {
              ForEach(0 ..< self.dates.count) {
                Text(self.dates[$0].formatDate())
              }
            }
          }
          .labelsHidden()
        }
          
          Button(action: {
            self.colorSet = (self.colorSet + 1) % self.colors.count
          }, label: {Text("Change Color")})
          
          VStack(alignment: .leading){
            Spacer()
            HStack(alignment: .top){
              Spacer()
              GreenButton("Add Journal").onTapGesture {
                self.addJournalToTrip()
              }
            }
          }
          
        }.navigationBarTitle(Text("Adding Journal"))
          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
          .padding(.leading, UIScreen.main.bounds.width * 0.05)
          .padding(.trailing,UIScreen.main.bounds.width * 0.05)
          .padding(.top,20)
    }
  }
  
  
  
}
