//
//  Recipe-CoreDataHelpers.swift
//  Cookooree
//
//  Created by Brandon Shearin on 11/15/20.
//

import Foundation
import SwiftUI

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
    
    var recipeName: String {
        name ?? ""
    }
    
    var recipeServings: String {
        servings ?? ""
    }
    
    var recipeSource: String {
        source ?? ""
    }
    
    static var example: Recipe {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let recipe = Recipe(context: viewContext)
        
        recipe.id = UUID()
        recipe.name = "Irish Soda Bread"
        recipe.duration = "1 hour"
        recipe.servings = "1 loaf"
        recipe.detail = "Irish soda bread is likeone big biscuit.  This version doesn't bother with whole wheat flour, making it lighter.  My kids like the whole wheat version, but they LOVE this one."
        recipe.ingredients = [
            "4 cups all-purpose flour",
            "1 tsp baking soda",
            "1 tsp kosher salt",
            "1 3/4 cups buttermilk"
        ]
        recipe.directions = "Preheat the oven to 425 degrees. \n In a large bowl, shift or whisk together the flour, baking soda, and salt.  Slowly stir in the buttermilk.  At some point, you will need to start using your hands to develop it into a nice round loaf shape.  If it's too wet, add a tablespoon of flour. \n Once you do that, you're done.  (Note: This is not a yeast loaf so don't knead it.  That will only overwork it.) \n Drop it into a dutch oven.  Slash the top about 1/2\" deep, and then repeat so that you have an x ont op.  Apparently this releases the fairies.  "
        recipe.source = "Julia MOskin via NY Times Cooking"
        recipe.creationDate = Date()
        
        let image = UIImage(named: "recipe-0")
        let imageData = image?.jpegData(compressionQuality: 1)
        recipe.image = imageData
        
        try? viewContext.save()
        
        return recipe
    }
}
