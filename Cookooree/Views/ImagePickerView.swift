//
//  ImagePicker.swift
//  Cookooree
//
//  Created by Brandon Shearin on 10/25/20.
//

import SwiftUI
import UIKit
import FirebaseStorage
import FirebaseUI

struct ImagePickerView: View {
    
    @State var shown = false
    @State var selectedImage = UIImage()
    
    @StateObject var viewModel: RecipeViewModel
    
    var body: some View {
        VStack {
            Button(action: {
                self.shown.toggle()
            }) {
                Image(systemName: "camera")
                    .foregroundColor(.black)
                    .imageScale(.large)
            }
            .sheet(isPresented: $shown) {
                ImagePicker(sourceType: .camera, selectedImage: $selectedImage.didSet { val in
                    viewModel.selectedImage = selectedImage
                })
            }
        }
        
        
    }
}

extension Binding {
    func didSet(execute: @escaping (Value) ->Void) -> Binding {
        return Binding(
            get: {
                return self.wrappedValue
            },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView(viewModel: RecipeViewModel())
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


