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
    Color(red: 1, green: 51/255, blue: 102/255, opacity: 0.25), // Pink
    Color(red: 1, green: 204/255, blue: 51/255, opacity: 0.25), // Yellow,
    Color(red: 51/255, green: 204/255, blue: 153/255, opacity: 0.25), // Green
    Color(red: 51/255, green: 204/255, blue: 1, opacity: 0.25), // Blue
    Color(red: 152/255, green: 102/255, blue: 204/255, opacity: 0.25), // Purple
]
