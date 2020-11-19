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
    
    @Binding var selectedImage: UIImage?
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        VStack {
            Button(action: {
                self.showActionSheet.toggle()
            }) {
                Image(systemName: "camera")
                    .foregroundColor(.black)
                    .imageScale(.large)
            }
            .actionSheet(isPresented: $showActionSheet){
                ActionSheet(title: Text("Add a photo"),
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
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
            }
        }
    }
    
}

struct ImagePicker_Previews: PreviewProvider {
    
    @State static var img: UIImage?
    
    static var previews: some View {
        ImagePickerView(selectedImage: $img)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var selectedImage: UIImage?
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


