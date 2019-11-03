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


struct imageSelectorResultRow : View{
  var imageList: [UIImage]
  var count: Int
  
  init(_ imageList: [UIImage]){
    self.imageList = imageList
    self.count = self.imageList.count
  }
  
  var body : some View{
        HStack(alignment: .top) {
          ForEach(self.imageList[0 ..< self.count], id: \.self){ photo in
            Image(uiImage: photo)
            .resizable()
            .scaledToFill()
              .frame(width: UIScreen.main.bounds.width/4,height: UIScreen.main.bounds.width/4)
            .clipped()
            .cornerRadius(10)
          }
        }
  }
}


struct imageSelectorResult : View{
  var imageList: [UIImage]
  var count: Int
  init(_ imageList: [UIImage]){
    self.imageList = imageList
    self.count = imageList.count
  }
  
  var body : some View{
    VStack(){
      ForEach(0 ..< self.count/4) { num in
        imageSelectorResultRow(self.imageList[1])
      }
    }

//    HStack(alignment: .top) {
//      ForEach(self.imageList[0 ..< self.count], id: \.self){ photo in
//        Image(uiImage: photo)
//        .resizable()
//        .scaledToFill()
//          .frame(width: UIScreen.main.bounds.width/4,height: UIScreen.main.bounds.width/4)
//        .clipped()
//        .cornerRadius(10)
//      }
//    }
  }
}

struct NewTripAddPhotos :  View{
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @State var isShowingImagePicker = false
  @State var imageList = [UIImage]()
  @State var imageAssetList = [PHObject]()
  
  init(){
    PHPhotoLibrary.requestAuthorization({_ in return})
  }

  
  var btnBack : some View { Button(action: {
       self.presentationMode.wrappedValue.dismiss()
      }) {
          HStack {
          Image("ic_back") // set image here
              .aspectRatio(contentMode: .fit)
              .foregroundColor(.white)
              Text("Previous")
          }
      }
  }
  

  var body: some View {
    VStack(alignment: .leading){
      imageSelectorResult(self.imageList)
      Button(action: {
        self.isShowingImagePicker.toggle()
      },label: {
        Text("Select Image").font(.system(size: 32)).sheet(isPresented: $isShowingImagePicker,content: {
          ImagePickerView(isPresented: self.$isShowingImagePicker, selectedImage: self.$imageList, selectedImageList: self.$imageAssetList)
        })
        }
      )
    
    }.navigationBarBackButtonHidden(true)
      .navigationBarItems(leading: btnBack)
  }
}





struct ImagePickerView: UIViewControllerRepresentable{
  
  @Binding var isPresented: Bool
  @Binding var selectedImage: [UIImage]
  @Binding var selectedImageList: [PHObject]
  
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
        }
      }
      self.parent.isPresented = false
    }
    
    
  }
  
  func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ImagePickerView>) {
    
  }
}
