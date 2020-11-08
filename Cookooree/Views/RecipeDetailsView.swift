//
//  RecipeDetailsView.swift
//  Cookooree
//
//  Created by Brandon Shearin on 10/24/20.
//

import SwiftUI

struct RecipeDetailsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var recipe: Recipe
    
    @State private var isEditing = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    RecipeHeading(name: recipe.name, duration: recipe.duration, servings: recipe.servings)
                    if recipe.pictureDownloadURL != "" {
                        GeometryReader { geo in
                            RemoteImage(url: recipe.pictureDownloadURL)
                                .aspectRatio(contentMode: .fill)
                                .frame(height: geo.size.width)
                                .cornerRadius(10)
                        }
                        .clipped()
                        .aspectRatio(contentMode: .fit)
                    }
                    Text(recipe.description)
                        .font(.body)
                    DetailView(heading: "Ingredients", content: recipe.ingredients)
                    DetailView(heading: "Directions", content: [recipe.directions])
                    DetailView(heading: "Source", content: [recipe.source])
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            FloatingActionButton(icon: "pencil"){
                isEditing.toggle()
            }
        }
        .sheet(isPresented: $isEditing) {
            RecipeEditView(viewModel: RecipeViewModel(recipe: recipe), mode: .edit) { result in
                if case .success(let action) = result, action == .delete {
                    self.presentationMode.wrappedValue.dismiss()
                }
                
            }
        }
    }
}

struct RecipeDetailsView_Previews: PreviewProvider {
    
    static var demoRecipe = Recipe(name: "Meatballs", duration: "15 mins", servings: "3 servings",description: "Very yummy", ingredients: ["pork", "beef", "breadcrumbs"], directions: "Do all the things.  And then do some more.  And keep adding that and add this.  Then bake for a little while.  Then add some sauce.", source: "Brandon's Fabulous Cookbook")
    
    static var previews: some View {
        NavigationView {
            RecipeDetailsView(recipe: demoRecipe)
                .environmentObject(User())
        }
        
    }
}

struct RecipeHeading: View {
    
    var name: String
    var duration: String
    var servings: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical, 12)
            HStack(spacing: 24) {
                if !duration.isEmpty {
                    HStack {
                        Image(systemName: "clock")
                        Text(duration)
                            .font(.subheadline)
                    }
                }
                if !servings.isEmpty {
                    HStack{
                        Image(systemName: "person.2")
                        Text(servings)
                            .font(.subheadline)
                    }
                }
                
                Spacer()
            }
        }
        
    }
}

struct DetailView: View {
    
    var heading: String
    var content: [String]
    
    enum Kind {
        case list
        case single
    }
    
    var kind: Kind = .single
    
    var body: some View {
        if !hide() {
            VStack(alignment: .leading) {
                Text(heading)
                    .font(.headline)
                    .fontWeight(.bold)
                ForEach(content, id: \.self) { item in
                    Text(item)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 8)
                }
            }
            
        }
    }
    
    private func hide() -> Bool {
        if kind == .single {
            return content.count == 0 || content[0].isEmpty
        }else if kind == .list {
            return content.isEmpty
        }
        return false
    }
}

