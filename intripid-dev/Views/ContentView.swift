//
//  ContentView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/27/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

import Firebase
import FirebaseFirestore


struct ContentView: View {
  @EnvironmentObject var settings: UserSettings
  
//  var body: some View {
//    NavigationView{
//      custView().navigationBarTitle("Home")
//    }
//  }
  var body: some View {
    // TODO: somehow remove the tab view when clicked on specific trip
    TabView {
      TripView(trips: tripsData)
          .tabItem {
            VStack {
              Image(systemName: "1.circle")
              Text("Trips")
            }
        }.tag(1)

        StatisticsView()
          .tabItem {
            VStack {
              Image(systemName: "2.circle")
              Text("Statistics")
            }
        }.tag(2)

      ProfileView()
          .tabItem {
            VStack {
              Image(systemName: "3.circle")
              Text("Profile")
            }
        }.tag(3)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//struct custView : View {
//  @State var msg = ""
//  @ObservedObject var datas = observer()
//  //var userData = getUserById()
//  var body : some View{
//    VStack{
//      List{
//        ForEach(datas.data){i in
//          HStack{
//            Text(i.msg)
//            NavigationLink(destination: modisy(id: i.id)){
//              Text("Edit")
//            }
//          }
//
//        }
//        .onDelete {(index) in
//          let id = self.datas.data[index.first!].id
//          let db = Firestore.firestore().collection("msgs")
//          db.document(id).delete {(err) in
//            if (err != nil){
//              print((err?.localizedDescription)!)
//              return
//            }
//            print("deleted successfully!")
//            self.datas.data.remove(atOffsets: index)
//          }
//
//
//        }
//      }
//
//      HStack{
//        TextField("Enter your name", text: $msg).textFieldStyle(RoundedBorderTextFieldStyle())
//        Button(action: {
//
//          print(self.msg)
//          self.addData(msg1:self.msg)
//        }){
//          Text("Add")
//        }.padding()
//      }.padding()
//    }
//  }
//
//  func addData(msg1: String){
//    let db = Firestore.firestore()
//    let msg = db.collection("msgs").document()
//
//    msg.setData(["id": msg.documentID, "msg": msg1]){(err) in
//      if err != nil{
//        print((err?.localizedDescription)!)
//        return
//      }
//      print("success")
//      self.msg = ""
//    }
//  }
//}
//
//
//struct datatype : Identifiable {
//  var id : String
//  var msg : String
//}
//
//class observer : ObservableObject {
//  @Published var data = [datatype]()
//  init (){
//    let db = Firestore.firestore().collection("msgs")
//    db.addSnapshotListener {(snap, err) in
//      if (err != nil) {
//        print((err?.localizedDescription)!)
//        return
//      }
//
//      for i in snap!.documentChanges{
//        if i.type == .added {
//          let msgData = datatype(id: i.document.documentID, msg: i.document.get("msg") as! String)
//          self.data.append(msgData)
//        }
//
//        if i.type == .modified{
//          for j in 0..<self.data.count{
//            if self.data[j].id == i.document.documentID {
//              self.data[j].msg = i.document.get("msg") as! String
//            }
//          }
//      }
//    }
//  }
//
//}
//}
//
//
//struct modisy : View {
//  @State var txt = ""
//  var id = ""
//  var body : some View {
//    VStack{
//      TextField("edit", text: $txt).textFieldStyle(RoundedBorderTextFieldStyle())
//
//      Button(action: {
//
//        let db = Firestore.firestore().collection("msgs")
//        db.document(self.id).updateData(["msg": self.txt]) {(err) in
//          if err != nil {
//            print((err?.localizedDescription)!)
//            return
//          }
//          print("success")
//        }
//      }) {
//        Text("Modify")
//      }
//
//    }
//  }
//}
//
