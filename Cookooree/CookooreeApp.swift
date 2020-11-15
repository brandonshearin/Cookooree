//
//  CookooreeApp.swift
//  Cookooree
//
//  Created by Brandon Shearin on 10/19/20.
//

import SwiftUI
import Firebase


class User: ObservableObject {
    
    @Published var uid: String = ""
    
    init(){
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard let user = authResult?.user else { return }
            self.uid = user.uid
        }
    }
}

@main
struct CookooreeApp: App {
    
    @StateObject var dataController: DataController
    
    var u: User
    
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
        
        FirebaseApp.configure()
        u = User()
    }
    
    var body: some Scene {
        WindowGroup {
            AllRecipesView()
                .environmentObject(u)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
    
}
