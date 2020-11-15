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
    
    @ObservedObject var recipesVM = RecipesViewModel()
    @State private var presentAddRecipeSheet = false
    @State private var presentation: mode = .asGrid
    
    @EnvironmentObject var user: User
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Barlow-Black", size: 21)!]
        
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if presentation == .asGrid {
                    RecipeGridView(recipes: recipesVM.recipes)
                } else {
                    RecipeListView(recipes: recipesVM.recipes)
                }
                
                FloatingActionButton() {
                    self.presentAddRecipeSheet.toggle()
                }
            }
            .navigationBarTitle("cookooree", displayMode: .inline)
            .navigationBarItems(leading: SettingsButton(action: {}),
                                trailing: GridListToggle(image: self.presentation == .asGrid ? "list.dash" : "square.grid.2x2") {
                                    if self.presentation == .asList {
                                        self.presentation = .asGrid
                                    } else {
                                        self.presentation = .asList
                                    }
                                })
            .sheet(isPresented: $presentAddRecipeSheet){
                RecipeEditView()
            }
            
        }
    }
}

struct SettingsButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: {self.action()}){
            Image(systemName: "gear")
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
    static var previews: some View {
        Group {
            AllRecipesView()
                .environmentObject(User())
        }
    }
}
