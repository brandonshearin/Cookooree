//
//  ImagePicker.swift
//  Cookooree
//
//  Created by Brandon Shearin on 10/25/20.
//

import SwiftUI
import UIKit

struct ImagePickerView: View {
    
    @State private var showImagePicker = false
    @State private var showActionSheet = false
    
    @Binding var selectedImage: UIImage
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        VStack {
            Button(action: {
                self.showActionSheet.toggle()
            }) {
                if imageIsNull(image: selectedImage) {
                    Image(systemName: "camera")
                        .foregroundColor(Color(.label))
                        .imageScale(.large)
                } else {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 32, height: 32)
                        .cornerRadius(3)
                }
            }
            .actionSheet(isPresented: $showActionSheet){
                if imageIsNull(image: selectedImage) {
                    // if no photo selected, show ADD sheet
                    return ActionSheet(title: Text("Add a photo"),
                                buttons: [
                                    .default(Text("Choose from Library")){
                                        self.sourceType = .photoLibrary
                                        self.showImagePicker = true
                                    },
                                    .default(Text("Take a photo")){
                                        self.sourceType = .camera
                                        self.showImagePicker = true
                                    },
                                    .cancel()
                                ])
                } else {
                    // if there is a photo already selected, show EDIT sheet
                   return ActionSheet(title: Text("Edit photo"),
                                      buttons: [
                                        .default(Text("Remove photo")) {
                                            self.selectedImage = UIImage()
                                        },
                                          .default(Text("Choose from Library")){
                                              self.sourceType = .photoLibrary
                                              self.showImagePicker = true
                                          },
                                          .default(Text("Take a photo")){
                                              self.sourceType = .camera
                                              self.showImagePicker = true
                                          },
                                          .cancel()
                                      ])
                }
              
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
            }
        }
        
    }
    
    func imageIsNull(image: UIImage) -> Bool {
        let size = CGSize(width: 0, height: 0)
        if image.size.width == size.width {
            return true
        }
        return false
    }
    
}

struct ImagePicker_Previews: PreviewProvider {
    
//    @State static var img = UIImage()
    @State static var img = UIImage(named: "TestImage")!
    
    static var previews: some View {
        ImagePickerView(selectedImage: $img)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var selectedImage: UIImage
    @Environment(\.presentationMode) private var presentationMode
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


