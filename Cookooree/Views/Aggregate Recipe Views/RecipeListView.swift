//
//  RecipeListView.swift
//  Cookooree
//
//  Created by Brandon Shearin on 11/3/20.
//

import SwiftUI

struct RecipeListView: View {
    
    let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"].map { $0.uppercased()}
    
    var recipes: [Recipe]
    var sortOrder: String
    
    var groupedRecipes: [[Recipe]] {
        recipes.reduce([[Recipe]]()) {
            guard var last = $0.last else { return [[$1]] }
            var collection = $0
            if last.first!.recipeName.first == $1.recipeName.first {
                last += [$1]
                collection[collection.count - 1] = last
            } else {
                collection += [[$1]]
            }
            return collection
        }
    }
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        ScrollView {
                ForEach(groupedRecipes, id: \.self) { group in
                    Group {
                        ForEach(group) { recipe in
                            NavigationLink(destination: RecipeDetailsView(recipe: recipe)){
                                RecipeRowView(recipe: recipe)
                            }
                        }
                        .onDelete { offsets in
                            let allRecipes = group
                            for offest in offsets {
                                let recipe = allRecipes[offest]
                                dataController.delete(recipe)
                            }
            
                            dataController.save()
                        }
                    }
                    .padding(.horizontal)
                    .id(group.first?.recipeName.prefix(1))
            
                }
            }
        
    }
}


struct RecipeListView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        NavigationView{
            RecipeListView(recipes: [Recipe.example, Recipe.example, Recipe.example, Recipe.example], sortOrder: "alphabet")
                .environmentObject(dataController)
        }
    }
}
