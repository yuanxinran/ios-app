//
//  SwiftUIView.swift
//  intripid-dev
//
//  Created by Anna Yuan on 12/11/19.
//  Copyright © 2019 zona. All rights reserved.
//


import Foundation
import SwiftUI
import Photos
import PhotosUI

struct SingleimageSelectorResult : View{
  var imageList: [UIImage]
  var count: Int
  init(_ imageList: [UIImage]){
    self.imageList = imageList
    self.count = imageList.count
  }
  
  var body : some View{
      VStack{
          ForEach(0 ... (self.count-1)/4, id: \.self) { row in
            HStack {
                ForEach(self.imageList[row * 4 ..< self.imageList.count].prefix(4) , id: \.self) { photo in
                  Image(uiImage: photo)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width * 0.21,height: UIScreen.main.bounds.width * 0.21)
                    .clipped()
                    .cornerRadius(10)
                }
            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
          }
      }
  }
}

struct AddTravelPartner :  View{
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @State var isShowingImagePicker = false
  @State var imageList = [UIImage]()
  @State var imageAssetList = [PHAsset]()
  var onDismiss: () -> ()
  var viewModel = EditTravelPartnerViewModel()
  @State var lastName: String = ""
  @State var firstName: String = ""
  
  
  init(onDismiss: @escaping () -> ()){
    PHPhotoLibrary.requestAuthorization({_ in return})
    self.onDismiss = onDismiss
  }
  
  func addTravelPartner(){
    self.onDismiss()
    viewModel.createTravelPartner(lastName: self.lastName, firstName: self.firstName, photo: self.imageAssetList[0], photoImage: self.imageList[0]){
      (result) in
      print(result)
      
    }
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      VStack {
         HStack{
           Button(action: {self.onDismiss()}) {
             Text("Close")
           }
           Spacer()
         }.padding(.bottom, 20)
      }
      VStack(alignment: .leading, spacing: 20.0){
        VStack(alignment: .leading, spacing: 20.0){
          Text("Add Travel Partner").font(.title).fontWeight(.bold)
          
          VStack(alignment: .leading, spacing: 8.0){
            HStack{
              Text("First Name").font(.headline)
              Text("*").font(.headline).foregroundColor(Color(.sRGB, red: 52.0/255.0, green: 121/255.0, blue: 137.0/255.0, opacity: 1.0))
            }
            
            TextField("First Name", text: $firstName).textFieldStyle(PlainTextFieldStyle())
          }
          
          VStack(alignment: .leading, spacing: 8.0){
            HStack{
              Text("Last Name").font(.headline)
              Text("*").font(.headline).foregroundColor(Color(.sRGB, red: 52.0/255.0, green: 121/255.0, blue: 137.0/255.0, opacity: 1.0))
            }
            
            TextField("Last Name", text: $lastName).textFieldStyle(PlainTextFieldStyle())
          }
          
          
          Button(action: {
            self.isShowingImagePicker.toggle()
          },label: {
            Text("Select Profile Image").foregroundColor(GreenColor).sheet(isPresented: $isShowingImagePicker,content: {
              SingleImagePickerView(isPresented: self.$isShowingImagePicker, selectedImage: self.$imageList, selectedImageList: self.$imageAssetList)
//              ImagePickerView(selectedImage: self.$imageList, selectedImageList: self.$imageAssetList)
            })
          }
          )
        }
        
        SingleimageSelectorResult(self.imageList)
        
      }
      VStack(alignment: .leading){
        HStack(alignment: .top){
          Spacer()

          if (self.imageList.count > 0 && self.lastName != "" && self.firstName != ""){
            GreenButton("Add Travel Partner").onTapGesture {
                             self.addTravelPartner()
                           }
            
          } else{
            GreyedButton("Add Travel Partner")
          }

        }
      }.padding(.top, 30)
      
      
    }.navigationBarBackButtonHidden(true)
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading).padding(.leading,20).padding(.trailing, 20).padding(.top, 20)
  }
}





struct SingleImagePickerView: UIViewControllerRepresentable{
  
  @Binding var isPresented: Bool
  @Binding var selectedImage: [UIImage]
  @Binding var selectedImageList: [PHAsset]
//  @Binding var selectedImageUrlList: [String]
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<SingleImagePickerView>) -> UIViewController{
    let controller = UIImagePickerController()
    controller.delegate = context.coordinator
    return controller
  }
  
  func makeCoordinator() -> SingleImagePickerView.Coordinator {
    return Coordinator(parent: self)
  }
  
  class Coordinator: NSObject, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let parent: SingleImagePickerView
    init(parent: SingleImagePickerView){
      self.parent = parent
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
      if let assetInfo = info[.phAsset] as? PHAsset {
        self.parent.selectedImageList = [assetInfo]
        if let selectedImage = info[.originalImage] as? UIImage {
          self.parent.selectedImage = [selectedImage]
        }
      }
      self.parent.isPresented = false
    }
    
    
  }
  
  func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<SingleImagePickerView>) {
    
  }
}
