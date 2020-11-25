//
//  RecipeDetailsView.swift
//  Cookooree
//
//  Created by Brandon Shearin on 10/24/20.
//

import SwiftUI

struct RecipeDetailsView: View {
    
    @ObservedObject var recipe: Recipe
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataController: DataController
    
    @State private var isEditing = false
    
    init(recipe: Recipe){
        _recipe = ObservedObject(wrappedValue: recipe)
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                GeometryReader { geo in
                    VStack(alignment: .leading, spacing: 32) {
                        RecipeHeading(
                            name: recipe.recipeName,
                            duration: recipe.recipeDuration,
                            servings: recipe.recipeServings)
                        if let uiImage = UIImage(data: recipe.recipeImage) {
                            
                            Image(uiImage: uiImage)
                                .resizable()
//                                .scaledToFill()
                                .aspectRatio( contentMode: .fill)
                                .frame(width: geo.size.width, height: geo.size.width)
                                .cornerRadius(10)
                                .clipped()
                        }
                        Text(recipe.recipeDetail)
                            .font(.body)
                        DetailView(heading: "Ingredients", content: recipe.recipeIngredients)
                        DetailView(heading: "Directions", content: [recipe.recipeDirections])
                        DetailView(heading: "Source", content: [recipe.recipeSource])
                        Spacer()
                    }
                }
                .padding(.horizontal)
            }
            FloatingActionButton(icon: "pencil"){
                isEditing.toggle()
            }
        }
        .sheet(isPresented: $isEditing) {
            RecipeEditView(recipe: recipe, mode: Mode.edit) { result in
                if case .success(let action) = result, action == .delete {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .environmentObject(dataController)
        }
    }
}
struct RecipeDetailsView_Previews: PreviewProvider {
    
    static var dataController = DataController.preview
    
    static var previews: some View {
        
        RecipeDetailsView(recipe: Recipe.example)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
        
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

