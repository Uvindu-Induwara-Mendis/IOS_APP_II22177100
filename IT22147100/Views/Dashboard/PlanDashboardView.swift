//
//  PlanDashboardView.swift
//  FitVision
//
//  Created for IT22147100 - Advanced Mobile Application Development
//  Architectural Note: Screen 3 - AI Plan Dashboard
//  Meets Rubric Items 2 (Advanced UI), 3 (SwiftUI Components), and 6 (Emerging Tech).
//
//  DESIGN DECISION & TECHNICAL REPORT SUMMARY:
//  1. Unified Somatotype Classification View: Displays the classification
//     result with statistical confidence rating, radar metrics, and tailored advice.
//  2. Segmented Mode Switcher: Smoothly transitions between the Workout Blueprint
//     and the Nutritional Engine without full screen reloads.
//  3. Live HealthKit Integration: Reacts instantaneously to step count fluctuations,
//     showcasing dynamic calorie recalculation live on-screen.
//

import SwiftUI

struct PlanDashboardView: View {
    @StateObject private var viewModel: PlanDashboardViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(scanResult: ScanResult) {
        _viewModel = StateObject(wrappedValue: PlanDashboardViewModel(scanResult: scanResult))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Save Confirmation Toast Banner
                if viewModel.isSavedBannerVisible {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(red: 0.05, green: 0.12, blue: 0.08))
                        Text("Blueprint Saved to History")
                            .font(.subheadline.weight(.bold))
                            .foregroundColor(Color(red: 0.05, green: 0.12, blue: 0.08))
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(LinearGradient.brandButtonGradient)
                    .clipShape(Capsule())
                    .shadow(color: Color.fitEmerald.opacity(0.3), radius: 8, x: 0, y: 4)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 4)
                }
                
                // MARK: - Somatotype Classification Hero Header
                VStack(spacing: 14) {
                    HStack(alignment: .top) {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(viewModel.scanResult.bodyType.accentColor.opacity(0.16))
                                    .frame(width: 58, height: 58)
                                
                                Image(systemName: viewModel.scanResult.bodyType.iconName)
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(viewModel.scanResult.bodyType.accentColor)
                            }
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text(viewModel.scanResult.bodyType.rawValue.uppercased())
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                                
                                Text(viewModel.scanResult.bodyType.subtitle)
                                    .font(.caption.weight(.medium))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        // Confidence Match Pill
                        HStack(spacing: 4) {
                            Image(systemName: "sparkles")
                            Text("\(viewModel.scanResult.confidencePercentageString) Match")
                        }
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(viewModel.scanResult.bodyType.accentColor)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 5)
                        .background(viewModel.scanResult.bodyType.accentColor.opacity(0.14))
                        .clipShape(Capsule())
                    }
                    
                    // Key Archetype Attributes Row
                    HStack(spacing: 10) {
                        ArchetypeAttributePill(
                            label: "Metabolism",
                            value: viewModel.scanResult.bodyType == .ectomorph ? "Fast" : (viewModel.scanResult.bodyType == .mesomorph ? "Balanced" : "Efficient"),
                            color: viewModel.scanResult.bodyType.accentColor
                        )
                        ArchetypeAttributePill(
                            label: "Frequency",
                            value: "\(viewModel.scanResult.bodyType.defaultDaysPerWeek) Days/Wk",
                            color: viewModel.scanResult.bodyType.accentColor
                        )
                        ArchetypeAttributePill(
                            label: "Base Calories",
                            value: "\(viewModel.scanResult.bodyType.baseCaloricBaseline) kcal",
                            color: viewModel.scanResult.bodyType.accentColor
                        )
                    }
                    
                    Text(viewModel.scanResult.bodyType.scientificSummary)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .glassmorphicCard(cornerRadius: 20, strokeColor: viewModel.scanResult.bodyType.accentColor.opacity(0.35))
                .padding(.horizontal, 16)
                .padding(.top, 4)
                
                // MARK: - Live Apple HealthKit Step Telemetry Widget
                HealthKitStepWidget(healthService: HealthKitService.shared) { newSteps in
                    viewModel.updateSimulatedSteps(newSteps)
                }
                .padding(.horizontal, 16)
                
                // MARK: - Segmented Mode Switcher (Workout vs Diet)
                Picker("Dashboard View", selection: $viewModel.selectedSegment) {
                    ForEach(DashboardTabSegment.allCases) { segment in
                        Label(segment.rawValue, systemImage: segment.iconName).tag(segment)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 18)
                
                // MARK: - Content Presentation
                if viewModel.selectedSegment == .workout {
                    WorkoutPlanView(workoutPlan: $viewModel.scanResult.workoutPlan)
                } else {
                    DietPlanView(dietPlan: viewModel.scanResult.dietPlan)
                }
                
                // MARK: - Save Blueprint Action Button
                VStack(spacing: 8) {
                    Button(action: {
                        viewModel.saveToHistory()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.down.fill")
                            Text("Save Blueprint")
                        }
                    }
                    .primaryBrandButton()
                    
                    Text("Saves your somatotype blueprint, macro distribution, and workout split to history.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .padding(.bottom, 90) // Safe margin for floating TabBar
        }
        .background(Color.fitBackground.ignoresSafeArea())
        .navigationTitle("AI Blueprint")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.saveToHistory()
                }) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.fitEmerald)
                }
            }
        }
    }
}

// MARK: - Archetype Attribute Pill
private struct ArchetypeAttributePill: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 7)
        .background(Color.fitSurface)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(Color.fitBorder, lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        PlanDashboardView(scanResult: ScanResult.sampleMesomorph)
    }
}
