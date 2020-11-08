//
//  RecipeEditViewModel.swift
//  Cookooree
//
//  Created by Brandon Shearin on 10/21/20.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseStorage
import UIKit

class RecipeViewModel: ObservableObject {
    
    @Published var user: User?
    
    @Published var recipe: Recipe
    @Published var modified = false
    
    @Published var ingredients: String = "" {
        didSet {
            let lines = ingredients.components(separatedBy: "\n")
            self.recipe.ingredients = lines
        }
    }
    
    @Published var selectedImage: UIImage?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(recipe: Recipe = Recipe(name: "", duration: "", servings: "")) {
        self.recipe = recipe
        self.$recipe
            .dropFirst()
            .sink { [weak self] recipe in
                self?.modified = true
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Data Handlers
    private var db = Firestore.firestore()
    private var storage = Storage.storage()
    
    private func addRecipe(_ recipe: Recipe){
        do {
            recipe.userId = user?.uid
            let _ = try db.collection("recipes").addDocument(from: recipe)
        } catch {
            print(error)
        }
    }
    
    private func updateRecipe(_ recipe: Recipe) {
        if let documentId = recipe.id {
            do {
                try db.collection("recipes").document(documentId).setData(from: recipe)
            }
            catch {
                print(error)
            }
        }
    }
    
    private func removeRecipe() {
        if let documentId = recipe.id {
            db.collection("recipes").document(documentId).delete { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateOrAdd(_ recipe: Recipe) {
        if let id = recipe.id {
            if let selectedImage = selectedImage {
                uploadPhoto(selectedImage: selectedImage, path: id ) {
                    self.updateRecipe(recipe)
                }
            } else {
                updateRecipe(recipe)
            }
            
        } else {
            if let selectedImage = selectedImage {
                uploadPhoto(selectedImage: selectedImage, path: UUID().uuidString) {
                    self.addRecipe(recipe)
                }
            } else {
                addRecipe(recipe)
            }
            
        }
    }
    
    private func uploadPhoto(selectedImage: UIImage, path: String, completion: @escaping () -> Void) {
        
        guard let data = selectedImage.jpegData(compressionQuality: 0.35) else {
            print("no image provided")
            return
        }
        
        let storageRef = storage.reference().child("recipePhotos/\(path)")
        
        _ = storageRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print(error!.localizedDescription)
                return
            }
            
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print(error!.localizedDescription)
                    return
                }
                
                self.recipe.pictureDownloadURL = downloadURL.absoluteString
                completion()
            }
            
        }
    }
    
    // MARK: - UI Handlers
    
    func save() {
        updateOrAdd(recipe)
    }
    
    func handleDoneTapped() {
        self.save()
    }
    
    func handleDeleteTapped() {
        self.removeRecipe()
    }
}
