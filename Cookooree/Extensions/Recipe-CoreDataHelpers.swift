//
//  Recipe-CoreDataHelpers.swift
//  Cookooree
//
//  Created by Brandon Shearin on 11/15/20.
//

import Foundation
import SwiftUI
import CoreData

extension Recipe {
    
    var recipeCreationDate: Date {
        creationDate ?? Date()
    }
    
    var recipeDetail: String {
        detail ?? ""
    }
    
    var recipeDirections: String {
        directions ?? ""
    }
    
    var recipeDuration: String {
        duration ?? ""
    }
    
    var recipeImage: Data {
        image ?? Data()
    }
    
    var recipeIngredients: [String] {
        ingredients ?? [String]()
    }
    
    var ingredientsForTextSearch: String {
        recipeIngredients.joined(separator: " ")
    }
    
    var recipeName: String {
        name ?? ""
    }
    
    var recipeServings: String {
        servings ?? ""
    }
    
    var recipeSource: String {
        source ?? ""
    }
    
    static let filterKeyPaths: [KeyPath<Recipe, String>] =
        [\.recipeName,\.recipeDirections, \.recipeSource, \.recipeDetail, \.ingredientsForTextSearch]
}

extension Recipe {
    
    static func search(
        _ searchString: String,
        _ recipes: FetchedResults<Recipe>) -> [Recipe]{
        
        let out: [Recipe]
        if searchString.isEmpty {
            out = recipes.map { $0 }
        } else {
            out = recipes.filter { element in
                Recipe.filterKeyPaths.contains {
                    element[keyPath: $0]
                        .localizedCaseInsensitiveContains(searchString)
                }
            }
        }
        return out
    }
    
    static func sort(
        _ by: String,
        _ recipes: [Recipe]
    ) -> [Recipe] {
        
        let out: [Recipe]
        if by == "creationTime" {
            out = recipes.sorted {
                $0.recipeCreationDate > $1.recipeCreationDate
            }
        } else {
            out = recipes.sorted {
                $0.recipeName < $1.recipeName
            }
        }
        return out
    }
}

