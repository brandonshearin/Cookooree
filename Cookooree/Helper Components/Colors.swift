//
//  Colors.swift
//  Cookooree
//
//  Created by Brandon Shearin on 11/4/20.
//

import Foundation
import SwiftUI


extension Color {
    static var random: Color {
        return randomColors.randomElement() ?? Color(red: 221/255, green: 221/255, blue: 221/255)
    }
}

let randomColors = [
    Color("Blue"),
    Color("Purple"),
    Color("Green"),
    Color("Pink"),
    Color("Yellow")
]
