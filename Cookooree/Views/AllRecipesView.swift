//
//  ContentView.swift
//  Cookooree
//
//  Created by Brandon Shearin on 10/19/20.
//

import SwiftUI

struct AllRecipesView: View {
    
    enum ActiveSheet: Identifiable {
        case settings, addRecipe
        
        var id: Int {
            hashValue
        }
    }
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var activeSheet: ActiveSheet?
    @AppStorage("layout") var layout = "List"
    @AppStorage("sortOrder") var sortOrder = "creationTime"
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
        
        
        if sortOrder == "creationTime" {
            orderedRecipes = filteredRecipes.sorted {
                $0.recipeCreationDate > $1.recipeCreationDate
            }
        } else {
            orderedRecipes = filteredRecipes.sorted {
                $0.recipeName < $1.recipeName
            }
        }
        
        if layout == "Grid" {
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
                        layout: $layout,
                        searchString: $searchString)
                        .padding(.horizontal)
                    if recipes.wrappedValue.count == 0 {
                        Text("Your recipes will appear here once you have recipes.")
                            .padding(.horizontal)
                    }
                        LayoutView
                    
                    
                }
                
                
                ActionButton
//                FloatingActionButton() {
//                    self.activeSheet = .addRecipe
//                }
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
    
    var ActionButton: some View {
        if self.recipes.wrappedValue.count == 0 {
            return FloatingActionButton(message: "Tap this button to create your first recipe") {
                self.activeSheet = .addRecipe
            }
        } else {
            return FloatingActionButton() {
                self.activeSheet = .addRecipe
            }
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




