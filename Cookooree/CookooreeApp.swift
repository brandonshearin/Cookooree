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
    
    var u: User
    
    init() {
        FirebaseApp.configure()
        u = User()
    }
    
     var body: some Scene {
        WindowGroup {
            AllRecipesView()
                .environmentObject(u)
        }
    }
    
}
