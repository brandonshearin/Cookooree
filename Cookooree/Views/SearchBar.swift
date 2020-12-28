//
//  SearchBar.swift
//  Cookooree
//
//  Created by Brandon Shearin on 11/25/20.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var sortOrder: String
    @Binding var layout: String
    
    @Binding var searchString: String
    @State private var isEditing = false
    @State private var iconHidden = false
    
    var body: some View {
        HStack {
            TextField("Search", text: $searchString.onChange {
                isEditing = true
            })
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
                                self.isEditing = false
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
            
            Group {
                IconSwitch(image: sortOrder == "alphabet" ? "clock" : "textformat.abc" ) {
                    if sortOrder == "creationTime" {
                        sortOrder = "alphabet"
                    } else {
                        sortOrder = "creationTime"
                    }
                }
                
                IconSwitch(image: layout == "Grid" ?
                            "list.dash" : "square.grid.2x2") {
                    if layout == "List" {
                        self.layout = "Grid"
                    } else if layout == "Grid" {
                        self.layout = "List"
                    } else {
                        self.layout = "Shitball"
                    }
                }
            }
            .isHidden(iconHidden, remove: true)
            
        }
        .padding()
    }
}

struct SearchBar_Previews: PreviewProvider {
    
    @State static var sortOrder = "creationTime"
    @State static var layout = "List"
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


extension View {
    
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    /// ```
    /// Text("Label")
    ///     .isHidden(true)
    /// ```
    ///
    /// Example for complete removal:
    /// ```
    /// Text("Label")
    ///     .isHidden(true, remove: true)
    /// ```
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
