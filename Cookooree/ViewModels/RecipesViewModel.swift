//
//  RecipesViewModel.swift
//  Cookooree
//
//  Created by Brandon Shearin on 10/19/20.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FRecipe: Identifiable, Codable {
    @DocumentID var id: String?
    @ServerTimestamp var createdAt: Timestamp?
    
    var userId: String?
    var pictureDownloadURL: String = ""
    
    var name: String = ""
    var duration: String = ""
    var servings: String = ""
    
    var description: String = ""
    var ingredients = [String]()
    var directions: String = ""
    
    var source: String = ""
    
    init(name: String, duration: String, servings: String){
        self.name = name
        self.duration = duration
        self.servings = servings
    }
    
    init(name: String, duration: String, servings: String, description: String, ingredients: [String], directions: String, source: String){
        self.name = name
        self.duration = duration
        self.servings = servings
        
        self.description = description
        self.ingredients = ingredients
        self.directions = directions
        
        self.source = source
    }
    
}

class RecipesViewModel: ObservableObject {
    @Published var recipes = [FRecipe]()
    
    private var db = Firestore.firestore()
    
    @Published var uid: String = ""
    
    init(){
        // take out anonymous auth if you need to.  The problem is i need to store the user id somewhere that the entire application can use it
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard let user = authResult?.user else { return }
            self.uid = user.uid
            
            self.fetchData(uid: self.uid)
            
        }
    }
    
    func fetchData(uid: String) {
        db.collection("recipes")
            .whereField("userId", isEqualTo: uid)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("no documents")
                    return
                }
                
                self.recipes = documents.compactMap{ queryDocumentSnapshot -> FRecipe? in
                    return try? queryDocumentSnapshot.data(as: FRecipe.self)
                }
            }
    }
    
    
}
