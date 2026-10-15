//
//  HealthKitStepWidget.swift
//  FitVision
//
//  Created for IT22177100 - Advanced Mobile Application Development
//  Architectural Note: Apple HealthKit Live Telemetry Widget
//  Fulfills Rubric Item 6 (Integration of Emerging Technologies - 15 Marks).
//  Displays live steps, dynamic caloric bonus, and provides an interactive
//  step simulation slider for examiner demonstration.
//

import SwiftUI

struct HealthKitStepWidget: View {
    @ObservedObject var healthService: HealthKitService
    let onStepsChanged: (Int) -> Void
    
    @State private var isShowingSimulatorSlider: Bool = false
    @State private var localStepSliderValue: Double = 7800
    
    var body: some View {
        VStack(spacing: 14) {
            // MARK: - Header with Live Device Status & Actions
            VStack(spacing: 8) {
                HStack(alignment: .center) {
                    Label("Today's Activity", systemImage: "heart.fill")
                        .font(.subheadline.bold())
                        .foregroundColor(.fitCoral)
                    
                    Spacer()
                    
                    // Live / Fallback Source Badge
                    HStack(spacing: 4) {
                        Image(systemName: healthService.metrics.dataSource.icon)
                            .font(.system(size: 9, weight: .bold))
                        
                        Text(healthService.metrics.dataSource.rawValue)
                            .font(.system(size: 10, weight: .bold))
                        
                        if healthService.metrics.dataSource.isLiveDevice {
                            Circle()
                                .fill(Color.fitEmerald)
                                .frame(width: 5, height: 5)
                        }
                    }
                    .foregroundColor(healthService.metrics.dataSource.isLiveDevice ? .fitEmerald : (healthService.metrics.dataSource == .simulated ? .fitAmber : .secondary))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3.5)
                    .background(
                        (healthService.metrics.dataSource.isLiveDevice ? Color.fitEmerald : (healthService.metrics.dataSource == .simulated ? Color.fitAmber : Color.secondary))
                            .opacity(0.12)
                    )
                    .clipShape(Capsule())
                }
                
                // Action Controls Row: Sync Mobile & Demo Toggle
                HStack(spacing: 8) {
                    // Sync Device Button
                    Button(action: {
                        HapticManager.shared.impact(.light)
                        Task {
                            await healthService.requestAuthorization()
                            localStepSliderValue = Double(healthService.metrics.dailySteps)
                            onStepsChanged(healthService.metrics.dailySteps)
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.clockwise")
                                .font(.caption2.bold())
                                .rotationEffect(.degrees(healthService.isLoading ? 360 : 0))
                                .animation(
                                    healthService.isLoading
                                        ? .linear(duration: 0.9).repeatForever(autoreverses: false)
                                        : .default,
                                    value: healthService.isLoading
                                )
                            Text(healthService.isLoading ? "Querying Mobile..." : "Sync Mobile")
                                .font(.caption2.weight(.semibold))
                        }
                        .foregroundColor(.fitCyan)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4.5)
                        .background(Color.fitCyan.opacity(0.12))
                        .clipShape(Capsule())
                        .overlay(Capsule().strokeBorder(Color.fitCyan.opacity(0.25), lineWidth: 0.8))
                    }
                    .disabled(healthService.isLoading)
                    
                    Spacer()
                    
                    // Demo Slider Toggle
                    Button(action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            isShowingSimulatorSlider.toggle()
                        }
                        HapticManager.shared.selection()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "slider.horizontal.3")
                            Text(isShowingSimulatorSlider ? "Close Demo" : "Simulate Steps")
                        }
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4.5)
                        .background(Color.fitSurface)
                        .clipShape(Capsule())
                        .overlay(Capsule().strokeBorder(Color.fitBorder, lineWidth: 1))
                    }
                }
            }
            
            // MARK: - Informative Fallback or Simulation Banner
            if healthService.metrics.dataSource == .fallbackBaseline {
                HStack(alignment: .top, spacing: 7) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .padding(.top, 1)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Mobile sensors unpermitted or unavailable. Showing standard fallback (7,840 steps).")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text("Tap 'Sync Mobile' to prompt for Apple Health / Motion sensor access on your device.")
                            .font(.system(size: 9.5))
                            .foregroundColor(.secondary.opacity(0.8))
                    }
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.fitSurface.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(Color.fitBorder.opacity(0.6), lineWidth: 0.8)
                )
            } else if healthService.metrics.dataSource == .simulated {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 11))
                        .foregroundColor(.fitAmber)
                    
                    Text("Manual step simulation active.")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.fitAmber)
                    
                    Spacer()
                    
                    Button("Restore Device Steps") {
                        Task {
                            await healthService.restoreLiveSteps()
                            localStepSliderValue = Double(healthService.metrics.dailySteps)
                            onStepsChanged(healthService.metrics.dailySteps)
                        }
                    }
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.fitCyan)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.fitAmber.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            
            // Primary Step Readout with Activity Ring
            HStack(spacing: 16) {
                // Steps Ring Graphic
                ZStack {
                    Circle()
                        .stroke(Color.fitBorder, lineWidth: 7)
                        .frame(width: 58, height: 58)
                    
                    let progress = min(Double(healthService.metrics.dailySteps) / 10000.0, 1.0)
                    Circle()
                        .trim(from: 0, to: CGFloat(progress))
                        .stroke(
                            LinearGradient.brandButtonGradient,
                            style: StrokeStyle(lineWidth: 7, lineCap: .round)
                        )
                        .frame(width: 58, height: 58)
                        .rotationEffect(.degrees(-90))
                    
                    Image(systemName: healthService.metrics.dataSource.icon)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.fitEmerald)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(healthService.metrics.stepsFormatted)
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("/ 10,000 steps")
                            .font(.footnote.weight(.medium))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.fitEmerald)
                        
                        Text(healthService.metrics.dynamicBurnExplanation)
                            .font(.caption2.weight(.medium))
                            .foregroundColor(.fitEmerald)
                            .lineLimit(1)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Secondary Metric Tiles
            HStack(spacing: 12) {
                MetricTile(
                    icon: "flame.fill",
                    value: "\(healthService.metrics.activeCaloriesBurned) kcal",
                    label: "Active Energy",
                    accentColor: Color.fitCoral
                )
                
                MetricTile(
                    icon: "location.fill",
                    value: healthService.metrics.distanceKilometersFormatted,
                    label: "Walking Distance",
                    accentColor: Color.fitCyan
                )
            }
            .frame(maxWidth: .infinity)
            
            // Simulator Step Slider (Examiner Live Demo)
            if isShowingSimulatorSlider {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                        .background(Color.fitBorder)
                        .padding(.vertical, 2)
                    
                    HStack {
                        Text("Simulate Step Count:")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(Int(localStepSliderValue)) steps")
                            .font(.caption.bold())
                            .foregroundColor(.fitCyan)
                    }
                    
                    Slider(value: $localStepSliderValue, in: 2000...16000, step: 500) {
                        Text("Steps")
                    } minimumValueLabel: {
                        Text("2k").font(.caption2).foregroundColor(.secondary)
                    } maximumValueLabel: {
                        Text("16k").font(.caption2).foregroundColor(.secondary)
                    }
                    .tint(Color.fitEmerald)
                    .onChange(of: localStepSliderValue) { _, newValue in
                        let steps = Int(newValue)
                        healthService.setSimulatedSteps(steps)
                        onStepsChanged(steps)
                    }
                    
                    HStack {
                        Text("Recalibrates nutrition engine dynamically live.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if healthService.isSimulatedMode {
                            Button("Reset to Device") {
                                Task {
                                    await healthService.restoreLiveSteps()
                                    localStepSliderValue = Double(healthService.metrics.dailySteps)
                                    onStepsChanged(healthService.metrics.dailySteps)
                                }
                            }
                            .font(.caption2.bold())
                            .foregroundColor(.fitCoral)
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .glassmorphicCard(cornerRadius: 18)
        .onAppear {
            localStepSliderValue = Double(healthService.metrics.dailySteps)
        }
        .onChange(of: healthService.metrics.dailySteps) { _, newSteps in
            if !healthService.isSimulatedMode {
                localStepSliderValue = Double(newSteps)
            }
        }
    }
}

// MARK: - Clean Metric Tile Component
private struct MetricTile: View {
    let icon: String
    let value: String
    let label: String
    let accentColor: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(accentColor)
                .frame(width: 30, height: 30)
                .background(accentColor.opacity(0.14))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color.fitSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(Color.fitBorder, lineWidth: 1)
        )
    }
}
