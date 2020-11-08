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

struct RecipeEditView: View {
    
    @EnvironmentObject var user: User
    
    @Environment(\.presentationMode) private var presentationMode 
    @StateObject var viewModel = RecipeViewModel()
    
    @State private var presentActionSheet = false
    
    var mode: Mode = .new
    
    var completionHandler: ((Result<Action, Error>) -> Void)?
    
    var body: some View {
        NavigationView {
            VStack {
                
                HStack(alignment: .top) {
                    FormInput(title: "Title", placeholder: "Name of recipe", field: $viewModel.recipe.name)
                    ImagePickerView(viewModel: viewModel)
                        .padding(.trailing)
                    
                }
                FormInput(title: "Description", placeholder: "Additional details (optional)", field: $viewModel.recipe.description)
                
                FormInput(title: "Ingredients", placeholder: "One ingredient per line", field: $viewModel.ingredients, inputType: .area)
                FormInput(title: "Directions", placeholder: "", field: $viewModel.recipe.directions, inputType: .area)
                
                FormInput(title: "Yield", placeholder: "How many servings", field: $viewModel.recipe.servings)
                FormInput(title: "Duration", placeholder: "Cooking time", field: $viewModel.recipe.duration)
                
                Spacer()
                if mode == .edit {
                    Section {
                        Button("Delete recipe") { self.presentActionSheet.toggle() }
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.vertical)
            .navigationBarTitle(mode == .new ? "New Recipe" : viewModel.recipe.name)
            .navigationBarTitleDisplayMode(mode == .new ? .inline : .large)
            .navigationBarItems(leading:
                                    Button(action: {self.handleCancelTapped()}){
                                        Text("Cancel")
                                    },
                                trailing: Button(action: {self.handleDoneTapped()}){
                                    Text(mode == .new ? "Save" : "Done")
                                }
                                .disabled(!viewModel.modified))
            .actionSheet(isPresented: $presentActionSheet) {
                ActionSheet(title: Text("Are you sure?"), buttons: [
                    .destructive(Text("Delete Recipe"), action: { self.handleDeleteTapped() }),
                    .cancel()
                ])
            }
        }
    }
    
    func handleCancelTapped(){
        dismiss()
    }
    
    func handleDoneTapped(){
        self.viewModel.user = user
        self.viewModel.handleDoneTapped()
        dismiss()
    }
    
    func handleDeleteTapped(){
        self.viewModel.handleDeleteTapped()
        self.dismiss()
        self.completionHandler?(.success(.delete))
    }
    
    func dismiss(){
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct RecipeEditView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeEditView()
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
        .padding(.horizontal)
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
        
    }
}

extension String {
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}

