//
//  RecipeEditView.swift
//  Cookooree
//
//  Created by Brandon Shearin on 10/21/20.
//

import SwiftUI
import Combine

enum Mode {
    case new
    case edit
}

enum Action {
    case delete
    case done
    case cancel
}

struct RecipeEditView: View {
    
    @State var recipe: Recipe?
    
    var mode: Mode
    var completionHandler: ((Result<Action, Error>) -> Void)?
    
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var presentActionSheet = false
    
    @State private var name =  ""
    @State private var servings = ""
    @State private var duration = ""
    
    @State private var detail = ""
    @State private var ingredients = [String]()
    @State private var directions = ""
    @State private var source = ""
    
    @State private var image = UIImage()
    
    @State private var ingredientsListStr = ""
    
    init() {
        UINavigationBar
            .appearance()
            .titleTextAttributes =
            [.font : UIFont(name: "Barlow-Black", size: 21)!]
        
        mode = .new
    }
    
    init(recipe: Recipe,
         mode: Mode = .new,
         completion: ((Result<Action, Error>) -> Void)?) {
        
        UINavigationBar
            .appearance()
            .titleTextAttributes =
            [.font : UIFont(name: "Barlow-Black", size: 21)!]
        
        self.mode = mode
        _recipe = State(wrappedValue: recipe)
        completionHandler = completion
        
        _name = State(wrappedValue: recipe.recipeName)
        _servings = State(wrappedValue: recipe.recipeServings)
        _duration = State(wrappedValue: recipe.recipeDuration)
        _detail = State(wrappedValue: recipe.recipeDetail)
        _ingredients = State(wrappedValue: recipe.recipeIngredients)
        _directions = State(wrappedValue: recipe.recipeDirections)
        _source = State(wrappedValue: recipe.recipeSource)
        
        _image = State(wrappedValue: UIImage(data: recipe.recipeImage) ?? UIImage())
        
        var ret = ""
        for ingredient in recipe.recipeIngredients {
            ret += ingredient + "\n"
        }
        _ingredientsListStr = State(wrappedValue: ret)
    }
    
    
    
    func update() {
        
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
        
        let trimmed = ingredientsListStr.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        let lines =  trimmed.components(separatedBy: "\n")
        recipe.ingredients = lines
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack(alignment: .top) {
                        FormInput(title: "Title",
                                  placeholder: "Name of recipe (required)",
                                  field: $name.onChange(update))
                        ImagePickerView(selectedImage: $image)
                            .padding(.trailing)
                    }
                    FormInput(title: "Description",
                              placeholder: "Additional details (optional)",
                              field: $detail.onChange(update))
                    
                    FormInput(title: "Ingredients",
                              placeholder: "One ingredient per line",
                              field: $ingredientsListStr.onChange(update))
                    
                    FormInput(title: "Directions",
                              placeholder: "",
                              field: $directions.onChange(update))
                    
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
                            .foregroundColor(Color(.systemRed))
                        }
                    }
                }
                .onTapGesture {
                    self.hideKeyboard()
                }
                .onAppear {
                    if recipe == nil {
                        recipe = Recipe(context: managedObjectContext)
                        recipe?.id = UUID()
                        recipe?.creationDate = Date()
                    }
                }
                .onDisappear {
                    if recipe?.recipeName == "" {
                        if let recipe = recipe {
                            recipe.objectWillChange.send()
                            self.dataController.delete(recipe)
                            self.dataController.save()
                        }
                        
                    }
                }
            }
            .padding(.vertical)
            .navigationBarTitle(screenTitle)
            .navigationBarTitleDisplayMode(.inline )
            .navigationBarItems(leading: cancelButton, trailing: doneButton)
            .alert(isPresented: $presentActionSheet) {
                Alert(
                    title: Text("Are you sure?"),
                    primaryButton: .destructive(Text("Delete Recipe"),
                    action: { self.handleDeleteTapped() }),
                    secondaryButton: .cancel())
            }
        }
    }
    
    var screenTitle : String {
        mode == .new ? "New Recipe" : recipe?.recipeName ?? ""
    }
    
    var cancelButton: some View {
        Button("Cancel") {
            managedObjectContext.rollback()
            dismiss()
        }
    }
    
    var doneButton: some View {
        Button(mode == .new ? "Save": "Done") {
            let imageData = image.jpegData(compressionQuality: 1)
            recipe?.image = imageData
            
            dataController.save()
            dismiss()
        }
        .disabled(name.isEmpty)
    }
    
    func handleDeleteTapped() {
        if let recipe = recipe {
            dataController.delete(recipe)
        }
        dataController.save()
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
        Group {
            RecipeEditView(recipe: Recipe.emptyExample, completion: nil)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
            
        }
    }
}

struct FormInput: View {
    
    var title: String
    var placeholder: String
    @Binding var field: String
    
    var height: CGFloat?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Barlow", size: 15.0, relativeTo: .callout))
                .padding(.horizontal, 8)
            GoodTextEditor(text: $field, placeholder: placeholder)
                .frame(minHeight: height)
            Divider()
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding([.horizontal,.bottom])
        .ignoresSafeArea(.keyboard)
    }
}

extension String {
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct GoodTextEditor: View {
    
    @Binding private var text: String
    var placeholder: String
    
    init(text: Binding<String>, placeholder: String) {
        UITextView.appearance().backgroundColor = .clear
        _text = text
        self.placeholder = placeholder
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(.placeholderText))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
            }
            ExpandingTextView(text: $text)
            
        }
    }
}


extension String {
    func removingLeadingSpaces() -> String {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: .whitespaces) }) else {
            return self
        }
        return String(self[index...])
    }
}

