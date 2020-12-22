//
//  RecipeGridView.swift
//  Cookooree
//
//  Created by Brandon Shearin on 11/3/20.
//

import SwiftUI

struct RecipeGridView: View {
    
//    var recipes: FetchedResults<Recipe>
    var recipes: [Recipe]

    let columns = [
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3)
    ]
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns,
                      alignment: .center,
                      spacing: 3){
                
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

    static var previews: some View {
        NavigationView{
            RecipeGridView(recipes:[Recipe.emptyExample])
        }
    }
}


struct GridTile: View {
    
    @ObservedObject var recipe: Recipe
    
    var body: some View {
        GeometryReader { gr in
            if let uiImage = UIImage(data: recipe.recipeImage) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height:gr.size.width)
            } else {
                Rectangle()
                    .foregroundColor(.random)
                    .overlay(
                        Text("this is a title")
                            .font(Font.custom("Barlow", size: 12))
                            .foregroundColor(.black)
                            .padding(.leading, 8),
                        alignment: .leading
                    )
                    .frame(height:gr.size.width)
            }
        }
        .clipped()
        .aspectRatio(1, contentMode: .fit)
    }
}
