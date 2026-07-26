//
//  KeyboardDismissExtension.swift
//  prototypeApp
//

import SwiftUI
import UIKit

struct DismissKeyboardOnTapModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                TapGesture().onEnded {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            )
    }
}

extension View {
    /// Enables tap anywhere on screen to dismiss keyboard without blocking interactive controls
    func dismissKeyboardOnTap() -> some View {
        self.modifier(DismissKeyboardOnTapModifier())
    }
    
    /// Explicitly resigns keyboard focus
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
