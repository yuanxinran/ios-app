//
//  EditTripAddPhotosViewControllerWrapper.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 11/23/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

import AssetsPickerViewController
import Photos

struct EditTripAddPhotosViewControllerWrapper: UIViewControllerRepresentable {
  
  //  @Binding var isPresented: Bool
  @Binding var selectedImage: [UIImage]
  @Binding var selectedImageList: [PHAsset]
  
  typealias UIViewControllerType = AssetsPickerViewController
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<EditTripAddPhotosViewControllerWrapper>) -> EditTripAddPhotosViewControllerWrapper.UIViewControllerType {
    print("[EditTripAddPhotosViewControllerWrapper] in makeUIViewController")
    let picker = AssetsPickerViewController()
    picker.pickerDelegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: EditTripAddPhotosViewControllerWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<EditTripAddPhotosViewControllerWrapper>) {
  }
  
  func makeCoordinator() -> EditTripAddPhotosViewControllerWrapper.Coordinator {
    return Coordinator(parent: self)
  }
  
  class Coordinator: NSObject, AssetsPickerViewControllerDelegate {
    let parent: EditTripAddPhotosViewControllerWrapper
    init(parent: EditTripAddPhotosViewControllerWrapper){
      self.parent = parent
    }
    
    // Helper function to convert a PHAsset to Optional(UIImage)
    // TODO:
    func getUIImage(asset: PHAsset) -> UIImage? {
      
      var img: UIImage?
      let manager = PHImageManager.default()
      let options = PHImageRequestOptions()
      options.version = .original
      options.isSynchronous = true
      
      manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options, resultHandler: {(image, info) in
        if let data = image {
          img = data
        }
      })
      return img
    }
    
    // Helper function to convert an array of PHAsset to an array of UIImage
    func getUIImageList(assets: [PHAsset]) -> [UIImage] {
      var images = [UIImage]()
      for asset in assets {
        if let image = getUIImage(asset: asset) {
          images.append(image)
        }
      }
      return images
    }
    
    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {}
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {}
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
      self.parent.selectedImageList += assets
      self.parent.selectedImage += getUIImageList(assets: assets)
      print("in assetsPicker", self.parent.selectedImageList)
    }
    func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
      return true
    }
    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {}
    func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool {
      return true
    }
    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {}
    
  }
}
