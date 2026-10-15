//
//  View+Extensions.swift
//  FitVision
//
//  Created for IT22177100 - Advanced Mobile Application Development
//  Architectural Note: View Extensions & Reusable View Modifiers
//  Provides accessibility helpers, dynamic type scaling helpers,
//  and easy application of custom glassmorphic styling.
//

import SwiftUI

extension View {
    /// Applies the reusable Frosted-Glass Neumorphic Card styling
    /// - Parameters:
    ///   - cornerRadius: Radius for the rounded card (default 20)
    ///   - strokeColor: Optional custom border color
    /// - Returns: Modified view with frosted glass depth, specular highlight border, and subtle shadow
    func glassmorphicCard(cornerRadius: CGFloat = 20, strokeColor: Color = Color.fitBorder) -> some View {
        self.modifier(GlassmorphicCardModifier(cornerRadius: cornerRadius, strokeColor: strokeColor))
    }
    
    /// Hides the keyboard gracefully when interacting with screens
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// Accessible dynamic typography helper ensuring text wraps gracefully without truncation
    func dynamicTypeAccessible(minScale: CGFloat = 0.8) -> some View {
        self.minimumScaleFactor(minScale)
            .lineLimit(nil)
    }
}
