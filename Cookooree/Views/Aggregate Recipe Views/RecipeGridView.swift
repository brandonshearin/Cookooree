//
//  RecipeGridView.swift
//  Cookooree
//
//  Created by Brandon Shearin on 11/3/20.
//

import SwiftUI

struct RecipeGridView: View {
    
    var recipes: [FRecipe]
    
    let columns = [
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3)
    ]
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 3, pinnedViews: [.sectionHeaders]){
                
                ForEach(recipes) { recipe in
                    NavigationLink(destination: RecipeDetailsView(recipe: recipe)
                    ) {
                        GridTile(recipe: recipe)
                    }
                    
                }
            }
        }
    }
}

struct RecipeGridView_Previews: PreviewProvider {
    
    @ObservedObject static var recipesVM = RecipesViewModel()
    static var previews: some View {
        NavigationView{
            RecipeGridView(recipes: recipesVM.recipes)
        }
    }
}

struct GridTile: View {
    
    var recipe: FRecipe
    
    var body: some View {
        GeometryReader { gr in
            if recipe.pictureDownloadURL != "" {
                RemoteImage(url: recipe.pictureDownloadURL)
                    .aspectRatio(contentMode: .fill)
                    .frame(height:gr.size.width)
            } else {
                Rectangle()
                    .foregroundColor(.random)
                    .overlay(
                        Text(recipe.name)
                            .font(Font.custom("Barlow", size: 12))
                            .foregroundColor(.black)
                    )
                    .frame(height:gr.size.width)
            }
        }
        .clipped()
        .aspectRatio(1, contentMode: .fit)
    }
}
