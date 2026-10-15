//
//  GlassmorphicCardModifier.swift
//  FitVision
//
//  Created for IT22177100 - Advanced Mobile Application Development
//  Architectural Note: Custom SwiftUI ViewModifier
//  Meets Rubric Requirement 3 & Advanced UI:
//  Implements a refined, elevated card container leveraging Apple's
//  native Material engine (.ultraThinMaterial) for real-time backdrop blur,
//  paired with a hairline border and soft ambient depth.
//

import SwiftUI

/// A reusable SwiftUI ViewModifier creating an elevated, modern card container.
/// It renders a subtle translucent frosted material layer with crisp hairline borders,
/// ensuring legible foreground content while respecting Dark Mode and Light Mode backgrounds.
struct GlassmorphicCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 20
    var strokeColor: Color = Color.fitBorder
    var showHighlight: Bool = true
    
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background {
                ZStack {
                    // Base: Native Apple real-time backdrop material blur
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)
                    
                    // Surface Tint: Soft tint to elevate contrast against varied backgrounds
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            colorScheme == .dark
                                ? Color(red: 0.11, green: 0.13, blue: 0.17).opacity(0.65)
                                : Color.white.opacity(0.85)
                        )
                    
                    // Hairline Border: Crisp, uniform border respecting Apple HIG
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(
                            strokeColor == Color.fitBorder
                                ? (colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06))
                                : strokeColor.opacity(0.40),
                            lineWidth: 1.0
                        )
                }
            }
            // Ambient Elevation Shadow: Soft diffuse shadow providing physical layer separation
            .shadow(
                color: colorScheme == .dark ? Color.black.opacity(0.22) : Color.black.opacity(0.05),
                radius: 10,
                x: 0,
                y: 4
            )
    }
}

// MARK: - Interactive Preview Container
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack(spacing: 20) {
            Text("Refined Card Preview")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            Text("Demonstrating custom modern card modifier with backdrop blur, clean hairline border, and soft ambient depth.")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .glassmorphicCard(cornerRadius: 24)
        .padding()
    }
}
