//
//  RecipeEditView.swift
//  Cookooree
//
//  Created by Brandon Shearin on 10/21/20.
//

import SwiftUI

enum Mode {
    case new
    case edit
}

enum Action {
    case delete
    case done
    case cancel
}

class NewRecipe: ObservableObject {
    
    var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}

struct RecipeEditView: View {
    
    var recipe: Recipe?

    @Environment(\.presentationMode) private var presentationMode

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    let mode: Mode
    var completionHandler: ((Result<Action, Error>) -> Void)?
    
    @State private var presentActionSheet = false
    
    @State private var name: String
    @State private var servings: String
    @State private var duration: String
    
    @State private var detail: String
    @State private var ingredients: [String]
    @State private var directions: String
    @State private var source: String
    
    init() {
        mode = .new
        _name = State(wrappedValue: "")
        _servings = State(wrappedValue: "")
        _duration = State(wrappedValue: "")
        _detail = State(wrappedValue: "")
        _ingredients = State(wrappedValue: [String]())
        _directions = State(wrappedValue: "")
        _source = State(wrappedValue: "")
        _ingredientsListStr = State(wrappedValue: "")
    }
    
    init(recipe: Recipe, mode: Mode = .new) {
        self.mode = mode
        self.recipe = recipe
        
        _name = State(wrappedValue: recipe.recipeName)
        _servings = State(wrappedValue: recipe.recipeServings)
        _duration = State(wrappedValue: recipe.recipeDuration)
        _detail = State(wrappedValue: recipe.recipeDetail)
        _ingredients = State(wrappedValue: recipe.recipeIngredients)
        _directions = State(wrappedValue: recipe.recipeDirections)
        _source = State(wrappedValue: recipe.recipeSource)
        
        var ret = ""
        for ingredient in recipe.recipeIngredients {
            ret += ingredient + "\n"
        }
        _ingredientsListStr = State(wrappedValue: ret)
    }
    
    @State private var ingredientsListStr: String
    
    func update() {
        
        if mode == .edit {
            guard let recipe = self.recipe else {
                fatalError("some weird shit happened")
            }
            
            recipe.objectWillChange.send()
            
            recipe.name = name
            recipe.servings = servings
            recipe.duration = duration
            recipe.detail = detail
            recipe.directions = directions
            recipe.source = source
            
            let lines = ingredientsListStr.components(separatedBy: "\n")
            recipe.ingredients = lines
            
        }
       
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack(alignment: .top) {
                        FormInput(title: "Title",
                                  placeholder: "Name of recipe",
                                  field: $name.onChange(update))
//                        ImagePickerView(selectedImage: $viewModel.selectedImage)
//                            .padding(.trailing)
                    }
                    FormInput(title: "Description",
                              placeholder: "Additional details (optional)",
                              field: $detail.onChange(update))
                    
                    FormInput(title: "Ingredients",
                              placeholder: "One ingredient per line",
                              field: $ingredientsListStr.onChange(update),
                              inputType: .area)
                    
                    FormInput(title: "Directions",
                              placeholder: "",
                              field: $directions.onChange(update),
                              inputType: .area)
                    
                    FormInput(title: "Total Time",
                              placeholder: "Cooking time",
                              field: $duration.onChange(update))
                    
                    FormInput(title: "Yield",
                              placeholder: "How many servings",
                              field: $servings.onChange(update))
                    
                    FormInput(title: "Adapted From",
                              placeholder: "Source",
                              field: $source.onChange(update))
                    
                    Spacer()
                    
                    if mode == .edit {
                        Section {
                            Button("Delete recipe") { self.presentActionSheet.toggle()
                            }
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .padding(.vertical)
            .navigationBarTitle(mode == .new ?
                                    "New Recipe" :
                                    recipe?.recipeName ?? "")
            .navigationBarTitleDisplayMode(.inline )
            .navigationBarItems(leading:
                                    Button("Cancel"){
                                        self.handleCancelTapped()
                                    },
                                trailing:
                                    Button(mode == .new ? "Save": "Done") {
                                    self.handleDoneTapped()
                                })
            //            .actionSheet(isPresented: $presentActionSheet) {
            //                ActionSheet(title: Text("Are you sure?"), buttons: [
            //                    .destructive(Text("Delete Recipe"), action: { self.handleDeleteTapped() }),
            //                    .cancel()
            //                ])
            //            }
        }
    }
    
    func handleCancelTapped(){
        managedObjectContext.rollback()
        dismiss()
    }
    
    func handleDoneTapped(){
        if mode == .new {
            let recipe = Recipe(context: managedObjectContext)
            recipe.id = UUID()
            recipe.creationDate = Date()
            recipe.detail = detail
            recipe.directions = directions
            recipe.duration = duration
            recipe.ingredients = ingredients
            recipe.name = name
            recipe.servings = servings
            recipe.source = source
        }
        dataController.save()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func handleDeleteTapped(){
        self.dismiss()
        self.completionHandler?(.success(.delete))
    }
    
    func dismiss(){
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct RecipeEditView_Previews: PreviewProvider {
    
    static var dataController = DataController.preview
    
    static var previews: some View {
        RecipeEditView(recipe: Recipe.example)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}


enum InputType {
    case field
    case area
}

struct FormInput: View {
    
    var title: String
    var placeholder: String
    @Binding var field: String
    
    var inputType: InputType = .field
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.callout)
                .fontWeight(.heavy)
            if inputType == .field {
                TextField(placeholder,
                          text: $field)
            }else if inputType == .area {
                TextArea(placeholder, text: $field)
            }
            
            Divider()
        }
        .padding([.horizontal,.bottom])
        .ignoresSafeArea(.keyboard)
    }
}

struct TextArea: View {
    private let placeholder: String
    @Binding var text: String
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
            HStack(alignment: .top) {
                text.isEmpty ? Text(placeholder) : Text("")
                Spacer()
            }
            .foregroundColor(Color.primary.opacity(0.25))
            .padding(EdgeInsets(top: 0, leading: 4, bottom: 7, trailing: 0))
        }
        .frame(minHeight: 150)
        
    }
}

extension String {
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}

