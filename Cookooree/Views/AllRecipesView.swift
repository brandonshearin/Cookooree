//
//  ContentView.swift
//  Cookooree
//
//  Created by Brandon Shearin on 10/19/20.
//

import SwiftUI

struct AllRecipesView: View {
    enum mode {
        case asGrid, asList
    }
    
    enum ActiveSheet: Identifiable {
        case settings, addRecipe
        
        var id: Int {
            hashValue
        }
    }
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var activeSheet: ActiveSheet?
    
    @State private var presentation: mode = .asGrid
    
    let recipes: FetchRequest<Recipe>
    
    init() {
        print("Howdy")
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Barlow-Black", size: 21)!]
        recipes = FetchRequest<Recipe>(
            entity: Recipe.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.creationDate, ascending: false)])
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if presentation == .asGrid {
                    let columns = [
                        GridItem(.flexible(), spacing: 3),
                        GridItem(.flexible(), spacing: 3),
                        GridItem(.flexible(), spacing: 3)
                    ]
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center, spacing: 3, pinnedViews: [.sectionHeaders]){
                            
                            ForEach(recipes.wrappedValue) { recipe in
                                NavigationLink(destination: RecipeDetailsView(recipe: recipe)
                                ) {
                                    GridTile(recipe: recipe)
                                }
                                
                            }
                        }
                    }
                } else {
                    List {
                        ForEach(recipes.wrappedValue) { recipe in
                            NavigationLink(destination: RecipeDetailsView(recipe: recipe)){
                                RecipeRowView(recipe: recipe)
                            }
                        }
                        .onDelete { offsets in
                            let allRecipes = recipes.wrappedValue
                            
                            for offest in offsets {
                                let recipe = allRecipes[offest]
                                dataController.delete(recipe)
                            }
                            
                            dataController.save()
                        }
                    }
                }
                FloatingActionButton() {
                    self.activeSheet = .addRecipe
                    //                    dataController.deleteAll()
                    //                    try? dataController.createSampleData()
                }
            }
            .sheet(item: $activeSheet) {item in
                switch item {
                case .addRecipe:
                    RecipeEditView()
                case .settings:
                    Settings()
                }
            }
            .navigationBarTitle("cookooree", displayMode: .inline)
            .navigationBarItems(leading: SettingsButton(action: {
                self.activeSheet = .settings
            }),
            trailing: GridListToggle(image: self.presentation == .asGrid ? "list.dash" : "square.grid.2x2") {
                if self.presentation == .asList {
                    self.presentation = .asGrid
                } else {
                    self.presentation = .asList
                }
            })
            
            
            
        }
    }
    
}

struct SettingsButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: {self.action()}){
            Image(systemName: "gear")
                .resizable()
                .imageScale(.large)
                .foregroundColor(.black)
                .padding([.vertical,.leading])
        }
    }
}
struct GridListToggle: View {
    
    var image: String
    
    var action: () -> Void
    
    var body: some View {
        Button(action: { self.action() }) {
            Image(systemName: image)
                .imageScale(.large)
                .foregroundColor(.black)
                .padding([.vertical,.leading])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        Group {
            AllRecipesView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
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
                        Text(recipe.recipeName)
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

struct RecipeRowView: View {
    
    @ObservedObject var recipe: Recipe
    
    var body: some View {
        HStack {
            Text(recipe.recipeName)
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
