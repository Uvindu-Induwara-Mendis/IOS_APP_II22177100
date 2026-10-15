//
//  DietPlanView.swift
//  FitVision
//
//  Created for IT22177100 - Advanced Mobile Application Development
//  Architectural Note: Dynamic Nutritional Engine Component
//  Displays animated macro donut charts, dynamic HealthKit caloric calibration,
//  hydration guidelines, and chronobiological meal suggestions.
//

import SwiftUI

struct DietPlanView: View {
    let dietPlan: DietPlan
    
    var body: some View {
        VStack(spacing: 16) {
            // MARK: - Macro Donut Chart Card
            VStack(spacing: 12) {
                HStack {
                    Label("Macronutrient Targets", systemImage: "chart.pie.fill")
                        .font(.caption.weight(.bold))
                        .foregroundColor(dietPlan.somatotype.accentColor)
                    Spacer()
                }
                
                MacroDonutChart(
                    calories: dietPlan.adjustedCalories,
                    proteinGrams: dietPlan.proteinGrams,
                    carbsGrams: dietPlan.carbsGrams,
                    fatGrams: dietPlan.fatGrams
                )
            }
            .glassmorphicCard(cornerRadius: 20)
            .padding(.horizontal, 16)
            
            // MARK: - Dynamic HealthKit Calorie Calibration Card
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: "bolt.heart.fill")
                        .font(.subheadline.bold())
                        .foregroundColor(.fitCoral)
                    
                    Text("Live Activity Calibration")
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                }
                
                Text(dietPlan.adjustmentExplanation)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Divider()
                    .background(Color.fitBorder)
                
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Base Baseline")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                        Text("\(dietPlan.baseCalories) kcal")
                            .font(.subheadline.bold())
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 2) {
                        Text("Step Bonus")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                        Text("+\(dietPlan.dynamicCalorieAdjustment) kcal")
                            .font(.subheadline.bold())
                            .foregroundColor(.fitEmerald)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Total Target")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                        Text("\(dietPlan.adjustedCalories) kcal")
                            .font(.subheadline.bold())
                            .foregroundColor(dietPlan.somatotype.accentColor)
                    }
                }
                .padding(.top, 2)
            }
            .glassmorphicCard(cornerRadius: 18)
            .padding(.horizontal, 16)
            
            // MARK: - Daily Hydration Target Card
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.fitCyan.opacity(0.14))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "drop.fill")
                        .font(.title3)
                        .foregroundColor(Color.fitCyan)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Daily Hydration Target")
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                    
                    Text("\(String(format: "%.1f", dietPlan.hydrationLiters)) Liters Water")
                        .font(.title3.weight(.bold))
                        .foregroundColor(Color.fitCyan)
                    
                    Text("Calibrated for metabolic clearance and thermoregulation.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .glassmorphicCard(cornerRadius: 18)
            .padding(.horizontal, 16)
            
            // MARK: - Chronobiological Meal Suggestions
            VStack(alignment: .leading, spacing: 12) {
                Text("Recommended Meal Timing")
                    .font(.headline.bold())
                    .foregroundColor(.primary)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 12) {
                    ForEach(dietPlan.meals) { meal in
                        MealSuggestionCard(meal: meal, accentColor: dietPlan.somatotype.accentColor)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - Meal Suggestion Card Component
private struct MealSuggestionCard: View {
    let meal: MealItem
    let accentColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(meal.title)
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                    
                    Label(meal.timingDescription, systemImage: "clock")
                        .font(.caption2.weight(.medium))
                        .foregroundColor(accentColor)
                }
                
                Spacer()
                
                Text("\(meal.calories) kcal")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(Color.fitSurface)
                    .clipShape(Capsule())
                    .overlay(Capsule().strokeBorder(Color.fitBorder, lineWidth: 1))
            }
            
            Text(meal.description)
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Macronutrient Mini Badges
            HStack(spacing: 8) {
                MiniMacroTag(title: "Protein", value: "\(meal.proteinGrams)g", color: Color.fitEmerald)
                MiniMacroTag(title: "Carbs", value: "\(meal.carbsGrams)g", color: Color.fitCyan)
                MiniMacroTag(title: "Fat", value: "\(meal.fatGrams)g", color: Color.fitViolet)
            }
            
            // Key Ingredients
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(meal.keyIngredients, id: \.self) { ingredient in
                        Text(ingredient)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.fitSurface)
                            .clipShape(Capsule())
                            .overlay(Capsule().strokeBorder(Color.fitBorder, lineWidth: 1))
                    }
                }
            }
        }
        .glassmorphicCard(cornerRadius: 16)
    }
}

private struct MiniMacroTag: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 7)
        .padding(.vertical, 3)
        .background(Color.fitSurface)
        .clipShape(Capsule())
        .overlay(Capsule().strokeBorder(Color.fitBorder, lineWidth: 1))
    }
}
