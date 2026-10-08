//
//  BodyClassificationType.swift
//  FitVision
//
//  Created for IT22147100 - Advanced Mobile Application Development
//  Architectural Note: Somatotype Domain Model
//  Encapsulates biological somatotype classification principles (Sheldon model),
//  tailored macronutrient ratios, metabolic profiles, and recommended training regimens.
//

import SwiftUI

/// CoreML Body Somatotype Classification Category
enum BodyClassificationType: String, CaseIterable, Identifiable, Codable {
    case ectomorph = "Ectomorph"
    case mesomorph = "Mesomorph"
    case endomorph = "Endomorph"
    
    var id: String { rawValue }
    
    // MARK: - Display Titles & Descriptions
    var title: String {
        switch self {
        case .ectomorph: return "Ectomorph Profile"
        case .mesomorph: return "Mesomorph Profile"
        case .endomorph: return "Endomorph Profile"
        }
    }
    
    var subtitle: String {
        switch self {
        case .ectomorph: return "Lean, Fast Metabolism & Hypertrophy Focus"
        case .mesomorph: return "Athletic, High Muscle Density & Progressive Overload"
        case .endomorph: return "Solid Build, Slower Metabolism & Metabolic Conditioning"
        }
    }
    
    var scientificSummary: String {
        switch self {
        case .ectomorph:
            return "Characterized by a lean frame, narrower shoulders and hips, and a rapid basal metabolic rate. Requires a caloric surplus with higher complex carbohydrates to facilitate muscle protein synthesis."
        case .mesomorph:
            return "Characterized by broad clavicles, a naturally muscular frame, and balanced metabolic efficiency. Responds rapidly to progressive resistance training with balanced macronutrient partitioning."
        case .endomorph:
            return "Characterized by a sturdier bone structure and a metabolic propensity to store energy efficiently. Benefits from higher protein, moderate healthy fats, controlled glycemic carbohydrates, and hybrid cardiovascular conditioning."
        }
    }
    
    // MARK: - Visual & Branding Design Tokens
    var iconName: String {
        switch self {
        case .ectomorph: return "figure.run"
        case .mesomorph: return "figure.strengthtraining.traditional"
        case .endomorph: return "figure.cross.training"
        }
    }
    
    var accentColor: Color {
        switch self {
        case .ectomorph: return Color.fitCyan
        case .mesomorph: return Color.fitEmerald
        case .endomorph: return Color.fitViolet
        }
    }
    
    // MARK: - Default Training Split
    var defaultTrainingSplit: String {
        switch self {
        case .ectomorph: return "Push / Pull / Legs Hypertrophy (3-4 Days/Week)"
        case .mesomorph: return "Upper / Lower Power & Hypertrophy (4-5 Days/Week)"
        case .endomorph: return "Full-Body Circuit & HIIT Hybrid (4 Days/Week)"
        }
    }
    
    var defaultDaysPerWeek: Int {
        switch self {
        case .ectomorph: return 4
        case .mesomorph: return 5
        case .endomorph: return 4
        }
    }
    
    // MARK: - Macronutrient Distribution (Percentages)
    /// Protein percentage of total caloric intake
    var proteinRatio: Double {
        switch self {
        case .ectomorph: return 0.25
        case .mesomorph: return 0.30
        case .endomorph: return 0.35
        }
    }
    
    /// Carbohydrate percentage of total caloric intake
    var carbsRatio: Double {
        switch self {
        case .ectomorph: return 0.55
        case .mesomorph: return 0.45
        case .endomorph: return 0.30
        }
    }
    
    /// Fat percentage of total caloric intake
    var fatRatio: Double {
        switch self {
        case .ectomorph: return 0.20
        case .mesomorph: return 0.25
        case .endomorph: return 0.35
        }
    }
    
    // MARK: - Base Caloric Targets
    var baseCaloricBaseline: Int {
        switch self {
        case .ectomorph: return 2550 // Needs surplus to gain muscle
        case .mesomorph: return 2300 // Athletic maintenance/recomposition
        case .endomorph: return 2050 // Moderate deficit/carb moderation
        }
    }
    
    var recommendedHydrationLiters: Double {
        switch self {
        case .ectomorph: return 3.2
        case .mesomorph: return 3.5
        case .endomorph: return 3.8
        }
    }
}
