//
//  ContentView.swift
//  Cookooree
//
//  Created by Brandon Shearin on 10/19/20.
//

import SwiftUI
import CoreData

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
    
    @AppStorage("screenOn") var screenOn = false
    
    @FetchRequest(
        entity: Recipe.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.creationDate, ascending: false)]
    )
    var recipes: FetchedResults<Recipe>

    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Barlow-Black", size: 21)!]
    }
    
    var LayoutView: some View {
        
        let filteredRecipes = Recipe.search(searchString, recipes)
        let sortedRecipes = Recipe.sort(sortOrder, filteredRecipes)
        
        if layout == "Grid" {
            return AnyView(
                RecipeGridView(recipes: sortedRecipes))
        } else {
            return AnyView(
                RecipeListView(recipes: sortedRecipes))
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
                    if recipes.count == 0 {
                        Text("Your recipes will appear here once you have recipes.")
                            .padding(.horizontal)
                    }
                        LayoutView
                }
                ActionButton
            }
            .onAppear {
                UIApplication.shared.isIdleTimerDisabled = screenOn
            }
            .sheet(item: $activeSheet) {item in
                switch item {
                case .addRecipe:
                    RecipeEditView()
                        .environmentObject(dataController)
                case .settings:
                    Settings(screenOn: $screenOn)
                }
            }
            .navigationBarTitle("cookooree", displayMode: .inline)
            .navigationBarItems(leading: SettingsButton(action: {
                self.activeSheet = .settings
            }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var ActionButton: some View {
        if self.recipes.count == 0 {
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
                .foregroundColor(Color(.label))
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




