//
//  RecipeListView.swift
//  Cookooree
//
//  Created by Brandon Shearin on 11/3/20.
//

import SwiftUI

struct RecipeListView: View {
    
    var recipes: [Recipe]
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        List {
            ForEach(recipes) { recipe in
                NavigationLink(destination: RecipeDetailsView(recipe: recipe)){
                    RecipeRowView(recipe: recipe)
                }
            }
            .onDelete { offsets in
                let allRecipes = recipes
                for offest in offsets {
                    let recipe = allRecipes[offest]
                    dataController.delete(recipe)
                }
                
                dataController.save()
            }
        }
        
    }
}


struct RecipeListView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        NavigationView{
            RecipeListView(recipes: [Recipe.example, Recipe.example, Recipe.example, Recipe.example])
                .environmentObject(dataController)
        }
    }
}

struct RecipeRowView: View {
    
    @ObservedObject var recipe: Recipe
    
    var body: some View {

            HStack {
                Text(recipe.recipeName)
                    .foregroundColor(Color(.label))
                Spacer()
                if let uiImage = UIImage(data: recipe.recipeImage){
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 32, height: 32)
                        .cornerRadius(3)
                        .padding([.vertical, .trailing], 10)
                } else {
                    Rectangle()
                        .frame(width: 32, height: 32)
                        .padding(.vertical, 10)
                        .foregroundColor(.clear)
                }
            }
       
    }
}
