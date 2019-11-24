//
//  NewTripAddPhotos.swift
//  intripid-dev
//
//  Created by Anna Yuan on 11/3/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import SwiftUI
import Photos
import PhotosUI

struct imageSelectorResult : View{
  var imageList: [UIImage]
  var count: Int
  init(_ imageList: [UIImage]){
    self.imageList = imageList
    self.count = imageList.count
  }
  
  var body : some View{
    ScrollView {
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
}

struct NewTripAddPhotos :  View{
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @State var isShowingImagePicker = false
  @State var imageList = [UIImage]()
  @State var imageAssetList = [PHAsset]()
//  @State var imageURLList = [String]()
  private var title: String
  private var travelPartners: [String]
  
  init(title: String, travelPartners: [String]){
    PHPhotoLibrary.requestAuthorization({_ in return})
    self.title = title
    self.travelPartners = travelPartners
  }
  
  
  var btnBack : some View { Button(action: {
    self.presentationMode.wrappedValue.dismiss()
  }) {
    HStack {
      Text("Previous")
    }
    }
  }
  
  
  var body: some View {
    VStack(alignment: .leading) {
      VStack(alignment: .leading, spacing: 20.0){
        VStack(alignment: .leading, spacing: 10.0){
          Text("Upload Photos").font(.title).fontWeight(.bold)
          Button(action: {
            self.isShowingImagePicker.toggle()
          },label: {
            Text("Select Image").foregroundColor(GreenColor).sheet(isPresented: $isShowingImagePicker,content: {
//              ImagePickerView(isPresented: self.$isShowingImagePicker, selectedImage: self.$imageList, selectedImageList: self.$imageAssetList)
              EditTripAddPhotosViewControllerWrapper(selectedImage: self.$imageList, selectedImageList: self.$imageAssetList)
            })
          }
          )
        }
        
        imageSelectorResult(self.imageList)
        
      }
      Spacer()
      VStack(alignment: .leading){
        HStack(alignment: .top){
          Spacer()
          NavigationLink(destination: NewTripSelectCover(title: self.title, travelPartners: self.travelPartners, imageList: self.imageList, imageAssetList: self.imageAssetList)){
            GreenButton("Next")
          }
        }
      }
      Spacer()
      
      
    }.navigationBarBackButtonHidden(true)
      .navigationBarItems(leading: btnBack)
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading).padding(.leading,20).padding(.trailing, 20)
  }
}





struct ImagePickerView: UIViewControllerRepresentable{
  
  @Binding var isPresented: Bool
  @Binding var selectedImage: [UIImage]
  @Binding var selectedImageList: [PHAsset]
//  @Binding var selectedImageUrlList: [String]
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIViewController{
    let controller = UIImagePickerController()
    controller.delegate = context.coordinator
    return controller
  }
  
  func makeCoordinator() -> ImagePickerView.Coordinator {
    return Coordinator(parent: self)
  }
  
  class Coordinator: NSObject, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let parent: ImagePickerView
    init(parent: ImagePickerView){
      self.parent = parent
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
      if let assetInfo = info[.phAsset] as? PHAsset {
        self.parent.selectedImageList.append(assetInfo)
        if let selectedImage = info[.originalImage] as? UIImage {
          self.parent.selectedImage.append(selectedImage)
//          self.parent.selectedImageUrlList.append(imageURL)
        }
      }
      self.parent.isPresented = false
    }
    
    
  }
  
  func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ImagePickerView>) {
    
  }
}
