//
//  ScanDetailView.swift
//  FitVision
//
//  Created for IT22177100 - Advanced Mobile Application Development
//  Architectural Note: History Detail Screen
//  Presents full telemetry and macro details of a saved Core Data scan record.
//

import SwiftUI

struct ScanDetailView: View {
    let record: ScanRecordEntity
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Photo Header
                if let data = record.imageData, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 280)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .strokeBorder(Color.fitBorder, lineWidth: 1)
                        )
                        .padding(.horizontal, 16)
                }
                
                // Record Overview Card
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Label(record.safeBodyType.rawValue.uppercased(), systemImage: record.safeBodyType.iconName)
                            .font(.headline.bold())
                            .foregroundColor(record.safeBodyType.accentColor)
                        
                        Spacer()
                        
                        Text(record.safeTimestamp.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(record.safePlanTitle)
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                    
                    if let notes = record.planNotes, !notes.isEmpty {
                        Text(notes)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .glassmorphicCard(cornerRadius: 20, strokeColor: record.safeBodyType.accentColor.opacity(0.35))
                .padding(.horizontal, 16)
                
                // Metric Pills
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        StatPillView(
                            icon: "flame.fill",
                            value: "\(record.targetCalories) kcal",
                            label: "Daily Calories",
                            accentColor: Color.fitCoral
                        )
                        
                        StatPillView(
                            icon: "calendar",
                            value: "\(record.workoutDays) days",
                            label: "Weekly Frequency",
                            accentColor: Color.fitEmerald
                        )
                    }
                    
                    HStack(spacing: 10) {
                        StatPillView(
                            icon: "figure.walk",
                            value: "\(record.stepCountSnapshot.formatted()) steps",
                            label: "HealthKit Steps",
                            accentColor: Color.fitCyan
                        )
                        
                        StatPillView(
                            icon: "sparkles",
                            value: "\(Int(record.confidence * 100))%",
                            label: "Match Score",
                            accentColor: Color.fitViolet
                        )
                    }
                }
                .padding(.horizontal, 16)
                
                // Historical Nutritional Breakdown
                VStack(alignment: .leading, spacing: 12) {
                    Text("Preserved Nutritional Targets")
                        .font(.headline.bold())
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                    
                    MacroDonutChart(
                        calories: Int(record.targetCalories),
                        proteinGrams: Int(record.proteinGrams),
                        carbsGrams: Int(record.carbsGrams),
                        fatGrams: Int(record.fatGrams)
                    )
                    .glassmorphicCard(cornerRadius: 20)
                    .padding(.horizontal, 16)
                }
                
                // Training Split Detail
                if let split = record.trainingSplit {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Assigned Training Split")
                            .font(.subheadline.bold())
                            .foregroundColor(.primary)
                        
                        Text(split)
                            .font(.footnote)
                            .foregroundColor(record.safeBodyType.accentColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassmorphicCard(cornerRadius: 18)
                    .padding(.horizontal, 16)
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 90) // Safe margin for floating TabBar
        }
        .background(Color.fitBackground.ignoresSafeArea())
        .navigationTitle("Historical Scan")
        .navigationBarTitleDisplayMode(.inline)
    }
}
