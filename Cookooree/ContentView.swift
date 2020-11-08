//
//  ContentView.swift
//  Cookooree
//
//  Created by Brandon Shearin on 10/19/20.
//

import SwiftUI

struct Recipe: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var duration: String?
    var servings: String?
}

let testData = [
    Recipe(name: "Cheeseburgers"),
    Recipe(name: "Spaghetti and Meatballs"),
    Recipe(name: "Chicken Quesdillas")
]

struct RecipeListView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
