//
//  SearchBar.swift
//  Cookooree
//
//  Created by Brandon Shearin on 11/25/20.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var sortOrder: AllRecipesView.SortOrder
    @Binding var layout: AllRecipesView.Layout
    
    @Binding var searchString: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Search", text: $searchString)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                 
                        if isEditing {
                            Button(action: {
                                self.searchString = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing {
                Button("Cancel") {
                    self.isEditing = false
                    self.searchString = ""
                    // dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                }
                .padding(.trailing, 10)
//                .transition(.move(edge: .trailing))
                .animation(.default)
            }
            
            IconSwitch(image: sortOrder == .alphabet ? "clock" : "textformat.abc" ) {
                if sortOrder == .creationTime {
                    sortOrder = .alphabet
                } else {
                    sortOrder = .creationTime
                }
            }
            
            IconSwitch(image: layout == .asGrid ? "list.dash" : "square.grid.2x2") {
                if layout == .asList {
                    layout = .asGrid
                } else {
                    layout = .asList
                }
            }
        }
        .padding()
    }
}

struct SearchBar_Previews: PreviewProvider {
    
    @State static var sortOrder = AllRecipesView.SortOrder.creationTime
    @State static var layout = AllRecipesView.Layout.asGrid
    @State static var searchString = ""
    
    static var previews: some View {
        SearchBar(
            sortOrder: $sortOrder,
            layout: $layout,
            searchString: $searchString)
    }
}

struct IconSwitch: View {
    
    var image: String
    
    var action: () -> Void
    
    var body: some View {
        Button(action: { self.action() }) {
//            if image == "alpha" {
//                Image("alpha")
//                    .imageScale(.large)
////                    .frame(width: 44, height:44)
//                    .padding(.leading)
//            }
            Image(systemName: image)
                .imageScale(.large)
                .foregroundColor(.black)
                .padding(.leading)
            
        }
    }
}
