//
//  Binding-OnChange.swift
//  Cookooree
//
//  Created by Brandon Shearin on 11/15/20.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            })
    }
}
