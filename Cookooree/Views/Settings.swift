//
//  Settings.swift
//  Cookooree
//
//  Created by Brandon Shearin on 11/20/20.
//

import SwiftUI

struct Settings: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var screenOn: Bool = false
    var body: some View {
        NavigationView {
            Form {
                Toggle("Keep screen on", isOn: $screenOn)
                Text("Tell a friend about Cookooree")
                    .foregroundColor(.blue)
                Text("Send feedback")
                    .foregroundColor(.blue)
                Text("Help")
                    .foregroundColor(.blue)
                Text("Privacy Policy")
                    .foregroundColor(.blue)
                Text("Terms of Use")
                    .foregroundColor(.blue)
                Text("Cookooree v1.0.0")
                    .foregroundColor(.gray)
                
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Image(systemName: "xmark")
                    .imageScale(.large)
                    .foregroundColor(.black)
            }
            
            )
        }
        
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Settings()
        }
        
    }
}
