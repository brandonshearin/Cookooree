//
//  DataController.swift
//  Cookooree
//
//  Created by Brandon Shearin on 11/12/20.
//

import CoreData
import SwiftUI


// DataController is responsible for setting up CoreData and handling our interactions with it
class DataController: ObservableObject {
    
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false){
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, err in
            storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            storeDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            storeDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.udf.Cookooree")
            
            if let err = err {
                fatalError("Fatal error loading store: \(err.localizedDescription)")
            }
            
            self.container.viewContext.automaticallyMergesChangesFromParent = true
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
        }
        
    }
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }

        return dataController
    }()
    
    func createSampleData() throws {
        
        let viewContext = container.viewContext
        
        for i in 1...10 {
            let recipe = Recipe(context: viewContext)
            
            recipe.id = UUID()
            
            recipe.creationDate = Date()
            
            recipe.name = "Recipe \(i)"
            recipe.source = "NY Times Cooking"
            recipe.detail = "This is a tasty recipe"
            recipe.duration = "30 minutes"
            recipe.servings = "6 bowls"
            
            let image = UIImage(named: "recipe-\(i)")
            let imageData = image?.jpegData(compressionQuality: 1)
            recipe.image = imageData
            
            recipe.directions = "In a large bowl, combine the lime zest, lime juice, fish sauce, vegetable oil, sesame oil, and sugar.  MIx until the sugar is dissolved.  Add the cabbage and jicama. Toss well.  Top with candied walnuts when ready to serve"
            
            recipe.ingredients = [
                "3 limes, zested and juiced",
                "2 tbsp fish sauce",
                "2 tbsp vegtable oil",
                "1 tbsp sugar",
                "1 head purple cabbage, shredded",
                "1 jicama, peeled and cut very fine into match sticks",
                "1 cup candied walnuts"]
        }
        
        
        try? viewContext.save()
    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Recipe.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? container.viewContext.execute(batchDeleteRequest)
    }
}
