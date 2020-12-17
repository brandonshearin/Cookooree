//
//  RecipeListView.swift
//  Cookooree
//
//  Created by Brandon Shearin on 11/3/20.
//

import SwiftUI

struct RecipeListView: View {
    
    let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"].map { $0.uppercased()}
    
    var recipes: [Recipe]
    var sortOrder: AllRecipesView.SortOrder
    
    var groupedRecipes: [[Recipe]] {
        recipes.reduce([[Recipe]]()) {
            guard var last = $0.last else { return [[$1]] }
            var collection = $0
            if last.first!.recipeName.first == $1.recipeName.first {
                last += [$1]
                collection[collection.count - 1] = last
            } else {
                collection += [[$1]]
            }
            return collection
        }
    }
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        // OLD APPROACH THAT WORKS
        ScrollView {
                ForEach(groupedRecipes, id: \.self) { group in
                    Group {
                        ForEach(group) { recipe in
                            NavigationLink(destination: RecipeDetailsView(recipe: recipe)){
                                RecipeRowView(recipe: recipe)
                            }
                        }
                        .onDelete { offsets in
                            let allRecipes = group
                            for offest in offsets {
                                let recipe = allRecipes[offest]
                                dataController.delete(recipe)
                            }
            
                            dataController.save()
                        }
                    }
                    .padding(.horizontal)
                    .id(group.first?.recipeName.prefix(1))
            
                }
            }
        
    }
    
    func sectionIndexTitles(proxy: ScrollViewProxy) -> some View {
        SectionIndexTitles(proxy: proxy, titles: alphabet)
            .frame(maxWidth: .infinity, alignment: .topTrailing)
            .padding()
    }
}

struct SectionIndexTitles: View {
    
    let proxy: ScrollViewProxy
    let titles: [String]
    @GestureState private var dragLocation: CGPoint = .zero
    
    var body: some View {
        VStack {
            ForEach(titles, id: \.self) { title in
                Text(title)
                    .background(dragObserver(title: title))
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .updating($dragLocation) { value, state, _ in
                    state = value.location
                }
        )
    }
    
    func dragObserver(title: String) -> some View {
        GeometryReader { geo in
            dragObserver(geometry: geo, title: title)
        }
    }
    
    func dragObserver(geometry: GeometryProxy, title: String) -> some View {
        if geometry.frame(in: .global).contains(dragLocation) {
            DispatchQueue.main.async {
                proxy.scrollTo(title, anchor: .top)
            }
        }
        
        return Rectangle().fill(Color.clear)
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        NavigationView{
            RecipeListView(recipes: [Recipe.example, Recipe.example, Recipe.example, Recipe.example], sortOrder: .alphabet)
                .environmentObject(dataController)
        }
    }
}







//ScrollViewReader { scroll in
//    ScrollView(showsIndicators: false) {
//        VStack {
//            ForEach(groupedRecipes, id: \.self) { group in
//                Group {
//                    Text(String(group.first!.recipeName.prefix(1)))
//                    ForEach(group, id: \.self){ recipe in
//                        Text("blah bah")
//                    }
//                            ForEach(group, id: \.self) { recipe in
//                                NavigationLink(destination: RecipeDetailsView(recipe: recipe)){
//                                    RecipeRowView(recipe: recipe)
//                                }
//                                Divider()
//                            }
//                }
//                .padding(.horizontal, 30)
//                .id(String(group.first!.recipeName.prefix(1)))
//            }
//        }.overlay(sectionIndexTitles(proxy: scroll))
//
//    }
//
//}
