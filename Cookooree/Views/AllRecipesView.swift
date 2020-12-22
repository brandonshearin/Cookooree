//
//  ContentView.swift
//  Cookooree
//
//  Created by Brandon Shearin on 10/19/20.
//

import SwiftUI

struct AllRecipesView: View {
    
    enum Layout {
        case asGrid, asList
    }
    
    enum SortOrder {
        case alphabet, creationTime
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
    @State private var presentation: Layout = .asGrid
    @State private var sortOrder: SortOrder = .creationTime
    @State private var searchString = ""
    
    @State private var screenOn = false
    
    let recipes: FetchRequest<Recipe>
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Barlow-Black", size: 21)!]
        recipes = FetchRequest<Recipe>(
            entity: Recipe.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.creationDate, ascending: false)])
    }
    
    var LayoutView: some View {
        
        var orderedRecipes: [Recipe]
        
        // filter recipes by search term BEFORE sorting
        var filteredRecipes: [FetchedResults<Recipe>.Element]
        if searchString.isEmpty {
            filteredRecipes = recipes.wrappedValue.map{ $0 }
        } else {
            filteredRecipes = recipes.wrappedValue.filter { element in
                Recipe.filterKeyPaths.contains {
                    element[keyPath: $0]
                        .localizedCaseInsensitiveContains(searchString)
                }
            }
        }
        
        
        if sortOrder == .creationTime {
            orderedRecipes = filteredRecipes.sorted {
                $0.recipeCreationDate > $1.recipeCreationDate
            }
        } else {
            orderedRecipes = filteredRecipes.sorted {
                $0.recipeName < $1.recipeName
            }
        }
        
        if presentation == .asGrid {
            return AnyView(
                RecipeGridView(recipes: orderedRecipes))
        } else {
            return AnyView(
                RecipeListView(recipes: orderedRecipes, sortOrder: sortOrder))
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    SearchBar(
                        sortOrder: $sortOrder,
                        layout: $presentation,
                        searchString: $searchString)
                    LayoutView
                }
                
                
                FloatingActionButton() {
                    self.activeSheet = .addRecipe
                }
            }
            .sheet(item: $activeSheet) {item in
                switch item {
                case .addRecipe:
                    RecipeEditView()
                case .settings:
                    Settings(screenOn: $screenOn)
                }
            }
            .navigationBarTitle("cookooree", displayMode: .inline)
            .navigationBarItems(leading: SettingsButton(action: {
                self.activeSheet = .settings
            }))
            
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
        VStack{
            HStack {
                Text(recipe.recipeName)
                    .foregroundColor(.black)
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
            Divider()
        }
       
    }
}
