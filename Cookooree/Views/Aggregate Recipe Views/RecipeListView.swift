////
////  RecipeListView.swift
////  Cookooree
////
////  Created by Brandon Shearin on 11/3/20.
////
//
//import SwiftUI
//
//struct RecipeListView: View {
//    var recipes: [FRecipe]
//    
//    var body: some View {
//        List {
//            ForEach(recipes) { recipe in
//                NavigationLink(destination: RecipeDetailsView(recipe: recipe)){
//                    HStack {
//                        Text(recipe.name)
//                        Spacer()
//                        if !recipe.pictureDownloadURL.isEmpty {
//                            RemoteImage(url: recipe.pictureDownloadURL)
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 32, height: 32)
//                                .cornerRadius(3)
//                                .padding(.vertical, 10)
//                                .padding(.trailing, 10)
//                            
//                        }
//                    }
//                }
//            }
//        }
//        .listStyle(PlainListStyle())
//        
//    }
//}
//
//struct RecipeListView_Previews: PreviewProvider {
//    @ObservedObject static var recipesVM = RecipesViewModel()
//    
//    static var previews: some View {
//        NavigationView{
//            RecipeListView(recipes: recipesVM.recipes)
//        }
//    }
//}
