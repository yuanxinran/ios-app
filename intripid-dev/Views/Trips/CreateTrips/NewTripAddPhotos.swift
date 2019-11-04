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


//struct imageSelectorResultRow : View{
//  var imageList: [UIImage]
//  var count: Int
//
//  init(_ imageList: [UIImage]){
//    self.imageList = imageList
//    self.count = self.imageList.count
//  }
//
//  var body : some View{
//    HStack(alignment: .top) {
//      ForEach(self.imageList[0 ..< self.count], id: \.self){ photo in
//        Image(uiImage: photo)
//          .resizable()
//          .scaledToFill()
//          .frame(width: UIScreen.main.bounds.width/4,height: UIScreen.main.bounds.width/4)
//          .clipped()
//          .cornerRadius(10)
//      }
//    }
//  }
//}


struct imageSelectorResult : View{
  var imageList: [UIImage]
  var count: Int
  init(_ imageList: [UIImage]){
    self.imageList = imageList
    self.count = imageList.count
  }
  
  var body : some View{
    VStack{
      if self.count != 0 { //check that self.imageList is not empty
        ForEach(0 ... (self.count-1)/4, id: \.self) { row in
          HStack {
            ForEach(self.imageList[row * 4 ..< self.imageList.count].prefix(4) , id: \.self) { photo in
              Image(uiImage: photo)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 0.23,height: UIScreen.main.bounds.width * 0.23) // TODO: change the width and height relative to geometryReader instead
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
    VStack {
      imageSelectorResult(self.imageList)
      Button(action: {
        self.isShowingImagePicker.toggle()
      },label: {
        Text("Select Image").sheet(isPresented: $isShowingImagePicker,content: {
          ImagePickerView(isPresented: self.$isShowingImagePicker, selectedImage: self.$imageList, selectedImageList: self.$imageAssetList)
        })
      }
      )
      
    }.navigationBarBackButtonHidden(true)
      .navigationBarItems(leading: btnBack)
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
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
