//
//  Color+Theme.swift
//  FitVision
//
//  Created for IT22147100 - Advanced Mobile Application Development
//  Architectural Note: Centralized Design System & Semantic Color Tokens
//  Ensures WCAG 2.1 AA accessibility contrast, native Dark Mode compliance,
//  and a unified, premium athletic health brand aesthetic.
//

import SwiftUI

extension Color {
    // MARK: - Brand Core Accents (Calibrated for High Legibility & Professional Athletic Feel)
    /// Athletic Emerald: High-energy primary accent used for active CTAs, success states, and workout highlights
    static let fitEmerald = Color(red: 0.16, green: 0.82, blue: 0.50)
    
    /// Precision Cyan: Analytical secondary accent representing vision scans, telemetry, and data streams
    static let fitCyan = Color(red: 0.22, green: 0.72, blue: 0.95)
    
    /// Iris Violet: Sophisticated accent used for somatotype categorization and archetype badges
    static let fitViolet = Color(red: 0.58, green: 0.44, blue: 0.94)
    
    /// Sunset Coral: High-contrast accent for energy metrics, calories, and cardiac telemetry
    static let fitCoral = Color(red: 1.0, green: 0.42, blue: 0.35)
    
    /// Solar Gold: Accent representing peak performance, coaching cues, and milestones
    static let fitGold = Color(red: 1.0, green: 0.74, blue: 0.20)

    // MARK: - Adaptive Semantic Backgrounds
    /// Adaptive card surface that provides depth in both Light and Dark appearances
    static let fitSurface = Color(uiColor: UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.11, green: 0.13, blue: 0.17, alpha: 0.95)
            : UIColor(red: 0.99, green: 0.99, blue: 1.0, alpha: 1.0)
    })
    
    /// Subtle card border color for clean hairline card boundaries
    static let fitBorder = Color(uiColor: UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(white: 1.0, alpha: 0.08)
            : UIColor(white: 0.0, alpha: 0.06)
    })
    
    /// Deep background grouped base
    static let fitBackground = Color(uiColor: UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.05, green: 0.06, blue: 0.08, alpha: 1.0)
            : UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1.0)
    })
}

// MARK: - Linear Gradient Presets
extension LinearGradient {
    /// Scanner laser beam gradient with smooth soft edges
    static let laserBeamGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.fitCyan.opacity(0.0),
            Color.fitCyan.opacity(0.65),
            Color.white,
            Color.fitEmerald.opacity(0.65),
            Color.fitEmerald.opacity(0.0)
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    /// Premium athletic CTA button gradient
    static let brandButtonGradient = LinearGradient(
        colors: [Color.fitEmerald, Color(red: 0.12, green: 0.74, blue: 0.62)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    /// Glass card specular reflection highlight
    static let glassReflection = LinearGradient(
        colors: [Color.white.opacity(0.08), Color.white.opacity(0.01)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
