//
//  NeumorphicPressableButton.swift
//  FitVision
//
//  Created for IT22147100 - Advanced Mobile Application Development
//  Architectural Note: Custom ButtonStyle Component
//  Implements dynamic tactile depth, spring compression on press,
//  and refined athletic aesthetics.
//

import SwiftUI

struct NeumorphicPressableButtonStyle: ButtonStyle {
    var gradient: LinearGradient = LinearGradient.brandButtonGradient
    var isEnabled: Bool = true
    
    @Environment(\.colorScheme) private var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundColor(isEnabled ? Color(red: 0.04, green: 0.10, blue: 0.06) : Color.secondary)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background {
                if isEnabled {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(gradient)
                        .shadow(
                            color: Color.fitEmerald.opacity(configuration.isPressed ? 0.10 : 0.25),
                            radius: configuration.isPressed ? 4 : 10,
                            x: 0,
                            y: configuration.isPressed ? 2 : 4
                        )
                } else {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06))
                }
            }
            .scaleEffect(configuration.isPressed && isEnabled ? 0.97 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
            .opacity(isEnabled ? 1.0 : 0.6)
    }
}

extension View {
    func primaryBrandButton(isEnabled: Bool = true) -> some View {
        self.buttonStyle(NeumorphicPressableButtonStyle(isEnabled: isEnabled))
    }
}
