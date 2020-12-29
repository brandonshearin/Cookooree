//
//  FloatingActionButton.swift
//  Cookooree
//
//  Created by Brandon Shearin on 10/26/20.
//

import SwiftUI

struct FloatingActionButton: View {
    
    var icon: String = "plus"
    var message: String?
    var action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                if let message = message {
                    Text(message)
                        .frame(width: 190)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(Color(.label))
                }
                Button(action: {self.action()}){
                    Image(systemName: icon)
                        .frame(width: 48, height: 48)
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
                .background(Color("MainPink"))
                .cornerRadius(24)
                .padding()
                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
            }
        }
    }
}

struct FloatingActionButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingActionButton(message: "Tap this button to create your first recipe") {
            
        }
        .environment(\.colorScheme, .dark)
    }
}
