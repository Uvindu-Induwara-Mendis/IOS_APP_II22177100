//
//  MacroDonutChart.swift
//  FitVision
//
//  Created for IT22177100 - Advanced Mobile Application Development
//  Architectural Note: Custom Animated Donut Chart Component
//  Visualizes dynamic macronutrient distribution (Protein, Carbs, Fat)
//  with smooth trim transitions and responsive geometry.
//

import SwiftUI

struct MacroDonutChart: View {
    let calories: Int
    let proteinGrams: Int
    let carbsGrams: Int
    let fatGrams: Int
    
    // Proportions
    private var totalGrams: Double {
        Double(max(proteinGrams + carbsGrams + fatGrams, 1))
    }
    
    private var proteinRatio: Double { Double(proteinGrams) / totalGrams }
    private var carbsRatio: Double { Double(carbsGrams) / totalGrams }
    private var fatRatio: Double { Double(fatGrams) / totalGrams }
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                // Background Track
                Circle()
                    .stroke(Color.fitBorder, lineWidth: 14)
                    .frame(width: 160, height: 160)
                
                // Fat Segment (Violet)
                Circle()
                    .trim(from: 0.0, to: CGFloat(fatRatio))
                    .stroke(Color.fitViolet, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.6), value: fatRatio)
                
                // Carbs Segment (Cyan)
                Circle()
                    .trim(from: CGFloat(fatRatio), to: CGFloat(fatRatio + carbsRatio))
                    .stroke(Color.fitCyan, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.6), value: carbsRatio)
                
                // Protein Segment (Emerald)
                Circle()
                    .trim(from: CGFloat(fatRatio + carbsRatio), to: 1.0)
                    .stroke(Color.fitEmerald, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.6), value: proteinRatio)
                
                // Center Telemetry Readout
                VStack(spacing: 2) {
                    Text("\(calories)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("DAILY KCAL")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.secondary)
                        .tracking(1.0)
                }
            }
            .padding(.top, 4)
            
            // Legend
            HStack(spacing: 12) {
                MacroLegendCard(
                    color: Color.fitEmerald,
                    title: "Protein",
                    amount: "\(proteinGrams)g",
                    percent: "\(Int(proteinRatio * 100))%"
                )
                
                MacroLegendCard(
                    color: Color.fitCyan,
                    title: "Carbs",
                    amount: "\(carbsGrams)g",
                    percent: "\(Int(carbsRatio * 100))%"
                )
                
                MacroLegendCard(
                    color: Color.fitViolet,
                    title: "Fats",
                    amount: "\(fatGrams)g",
                    percent: "\(Int(fatRatio * 100))%"
                )
            }
        }
    }
}

private struct MacroLegendCard: View {
    let color: Color
    let title: String
    let amount: String
    let percent: String
    
    var body: some View {
        VStack(spacing: 3) {
            HStack(spacing: 5) {
                Circle()
                    .fill(color)
                    .frame(width: 7, height: 7)
                
                Text(title)
                    .font(.caption2.weight(.medium))
                    .foregroundColor(.secondary)
            }
            
            Text(amount)
                .font(.subheadline.bold())
                .foregroundColor(.primary)
            
            Text(percent)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.fitSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(Color.fitBorder, lineWidth: 1)
        )
    }
}
