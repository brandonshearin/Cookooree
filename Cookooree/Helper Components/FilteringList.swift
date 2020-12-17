//
//  FilteringList.swift
//  Cookooree
//
//  Created by Brandon Shearin on 12/10/20.
//

import SwiftUI

struct FilteringList<T: Identifiable, Content: View>: View {
    
    @State private var filteredItems = [T]()
    @State private var filterString = ""
    
    let listItems: [T]
    let filterKeyPaths: [KeyPath<T, String>]
    let content: (T) -> Content
    
    init(_ data: [T], filterKeys: KeyPath<T, String>..., @ViewBuilder rowContent: @escaping (T) -> Content) {
        
        listItems = data
        filterKeyPaths = filterKeys
        content = rowContent
    }
    
    var body: some View {
        VStack {
            TextField("Type to filter", text: $filterString.onChange(applyFilter))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            List(filteredItems, rowContent: content)
            
        }
        .onAppear(perform: applyFilter)
        
    }
    
    func applyFilter() {
        let cleanedFilter = filterString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedFilter.isEmpty {
            filteredItems = listItems
        } else {
            filteredItems = listItems.filter { element in
                filterKeyPaths.contains {
                    element[keyPath: $0]
                        .localizedCaseInsensitiveContains(cleanedFilter)
                }
            }
        }
    }
}


struct FilteringList_Previews: PreviewProvider {
    
    static var previews: some View {
        FilteringList([Recipe.example, Recipe.example], filterKeys: \.recipeName) { recipe in
            Text(recipe.recipeName)
        }
    }
}
