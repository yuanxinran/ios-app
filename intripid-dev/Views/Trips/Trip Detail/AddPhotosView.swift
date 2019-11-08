//
//  AddPhotosView.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/29/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
  
  @Environment(\.presentationMode)
  var presentationMode
  
  @Binding var image: Image?
  
  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var presentationMode: PresentationMode
    @Binding var image: Image?
    
    init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>) {
      _presentationMode = presentationMode
      _image = image
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
      image = Image(uiImage: uiImage)
      presentationMode.dismiss()
      
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      presentationMode.dismiss()
    }
    
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(presentationMode: presentationMode, image: $image)
  }
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController,
                              context: UIViewControllerRepresentableContext<ImagePicker>) {
    
  }
  
}

struct AddPhotosView: View {
  
  var onDismiss: () -> ()
  
  @State var showImagePicker: Bool = false
  @State var image: Image? = nil
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        VStack (alignment: .leading){
          Text("Add Photos")
            .font(.title)
            .fontWeight(.bold)
          
          HStack {
            self.image?
              .resizable()
              .frame(minWidth: 0, maxWidth: geometry.size.width / 4, minHeight: 0, maxHeight: geometry.size.width / 4, alignment: Alignment.topLeading)
              .cornerRadius(5)
            
            Button(action: {
              withAnimation {
                self.showImagePicker.toggle()
              }
            }) {
              ZStack {
                Rectangle()
                  .fill(Color.yellow)
                  .cornerRadius(5)
                VStack {
                  Text("+").font(.title)
                  Text("Select Photos").font(.caption)
                }
              }.frame(minWidth: 0, maxWidth: geometry.size.width / 4, minHeight: 0, maxHeight: geometry.size.width / 4, alignment: Alignment.topLeading)
            }
          }
         
          self.image?.resizable().frame(width: 200, height: 200)
          
          Spacer() //Push heading upwards and other buttons down?
          
          HStack {
            Button(action: { self.onDismiss() }) {
              Text("Dismiss")
            }
            Spacer()
            Button(action: {}) {
              Text("Upload Photos")
            }
          }
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.topLeading)
          .sheet(isPresented: self.$showImagePicker) {
          ImagePicker(image: self.$image)
        }
      }
    }.padding(20)
  }
}

//struct AddPhotosView: View {
//
//  var onDismiss: () -> ()
//
//    var body: some View {
//      VStack {
//        Text("Upload Photos")
//          .font(.title)
//          .fontWeight(.bold)
//        Button(action: { self.onDismiss() }) {
//            Text("Dismiss")
//        }
//      }
//    }
//}

struct AddPhotosView_Previews: PreviewProvider {
  static var previews: some View {
    AddPhotosView(onDismiss: {return})
  }
}
