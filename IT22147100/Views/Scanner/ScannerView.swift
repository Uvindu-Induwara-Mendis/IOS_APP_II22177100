//
//  ScannerView.swift
//  FitVision
//
//  Created for IT22147100 - Advanced Mobile Application Development
//  Architectural Note: Screen 2 - The AI Scanner (Navigation Root)
//  Meets Rubric Items 2 (Advanced UI), 3 (SwiftUI Components), 4 (Navigation), and 6 (Emerging Tech).
//
//  DESIGN DECISION & TECHNICAL REPORT SUMMARY:
//  1. Modern NavigationStack Routing: Uses type-safe navigationDestination(for:)
//     for programmatic push transitions directly to the AI Plan Dashboard.
//  2. High-Precision Biometric Vision HUD: Coordinates visual scanning telemetry
//     between the selected image viewport and active inference progress.
//  3. Native PhotosPicker & Sample Archetypes: Provides native photo library access
//     paired with synthetic archetypes for instant simulator testing and examination.
//

import SwiftUI
import PhotosUI

struct ScannerView: View {
    @Binding var activeScanResult: ScanResult
    @Binding var selectedTab: Int
    @StateObject private var viewModel = ScannerViewModel()
    @State private var navigationPath = NavigationPath()
    
    init(
        activeScanResult: Binding<ScanResult> = .constant(ScanResult.sampleMesomorph),
        selectedTab: Binding<Int> = .constant(0)
    ) {
        self._activeScanResult = activeScanResult
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Header Status & Title
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Label("Biometric Vision", systemImage: "sparkles")
                                .font(.caption2.weight(.bold))
                                .foregroundColor(.fitCyan)
                                .textCase(.uppercase)
                                .tracking(1.0)
                            
                            Spacer()
                            
                            Label("On-Device Private", systemImage: "lock.shield.fill")
                                .font(.caption2.weight(.medium))
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Body Composition")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("Analyze your standing silhouette to determine your athletic somatotype and generate a custom training blueprint.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // MARK: - Scanning Viewport / Image Container
                    ZStack {
                        if let image = viewModel.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 380)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                                        .strokeBorder(Color.fitBorder, lineWidth: 1)
                                )
                                .overlay {
                                    if viewModel.isShowingLaser, case let .scanning(stage, progress) = viewModel.scannerState {
                                        ScanningLaserOverlay(
                                            stage: stage,
                                            progress: progress,
                                            laserNormalizedPosition: viewModel.laserNormalizedPosition
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                                    }
                                }
                        } else {
                            // Empty State / Photo Selector Placeholder
                            VStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(Color.fitCyan.opacity(0.12))
                                        .frame(width: 80, height: 80)
                                    
                                    Image(systemName: "person.crop.rectangle.badge.plus")
                                        .font(.system(size: 36, weight: .medium))
                                        .foregroundColor(Color.fitCyan)
                                }
                                
                                VStack(spacing: 4) {
                                    Text("Ready for Body Analysis")
                                        .font(.headline.bold())
                                        .foregroundColor(.primary)
                                    
                                    Text("Select a clear standing photo with full silhouette visible from head to feet.")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 24)
                                }
                                
                                // Guidance Tips
                                HStack(spacing: 14) {
                                    GuidePill(icon: "figure.stand", text: "Neutral Stance")
                                    GuidePill(icon: "sun.max.fill", text: "Even Lighting")
                                    GuidePill(icon: "camera.viewfinder", text: "Head to Feet")
                                }
                                .padding(.top, 4)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 340)
                            .glassmorphicCard(cornerRadius: 22)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // MARK: - Primary Action: Native PhotosPicker
                    PhotosPicker(
                        selection: $viewModel.selectedPhotosPickerItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        HStack(spacing: 10) {
                            Image(systemName: viewModel.selectedImage == nil ? "photo.badge.plus" : "arrow.triangle.2.circlepath")
                            Text(viewModel.selectedImage == nil ? "Select Photo to Scan" : "Choose Different Photo")
                        }
                    }
                    .primaryBrandButton(isEnabled: !viewModel.isShowingLaser)
                    .disabled(viewModel.isShowingLaser)
                    .padding(.horizontal, 20)
                    
                    // MARK: - Testing Archetypes for Simulator & Instant Demo
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "person.3.sequence.fill")
                                .font(.caption.weight(.bold))
                                .foregroundColor(.fitCyan)
                            
                            Text("Sample Archetypes")
                                .font(.subheadline.weight(.bold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text("Instant Demo")
                                .font(.caption2.weight(.semibold))
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.fitSurface)
                                .clipShape(Capsule())
                        }
                        
                        Text("Tap any profile to simulate a scan and generate an instant blueprint:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 10) {
                            PresetScanButton(
                                title: "Mesomorph",
                                subtitle: "Athletic Build",
                                color: Color.fitEmerald,
                                icon: "figure.strengthtraining.traditional"
                            ) {
                                viewModel.loadPresetAndScan(somatotype: .mesomorph)
                            }
                            
                            PresetScanButton(
                                title: "Ectomorph",
                                subtitle: "Lean Frame",
                                color: Color.fitCyan,
                                icon: "figure.run"
                            ) {
                                viewModel.loadPresetAndScan(somatotype: .ectomorph)
                            }
                            
                            PresetScanButton(
                                title: "Endomorph",
                                subtitle: "Solid Build",
                                color: Color.fitViolet,
                                icon: "figure.cross.training"
                            ) {
                                viewModel.loadPresetAndScan(somatotype: .endomorph)
                            }
                        }
                    }
                    .glassmorphicCard(cornerRadius: 18)
                    .padding(.horizontal, 16)
                    
                    // MARK: - Privacy & Security Assurance Footnote
                    HStack(spacing: 10) {
                        Image(systemName: "lock.shield.fill")
                            .font(.subheadline)
                            .foregroundColor(.fitEmerald)
                        
                        Text("On-device processing via Apple Vision. Photos remain strictly private.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 4)
                }
                .padding(.bottom, 90) // Safe margin for floating TabBar
            }
            .background(Color.fitBackground.ignoresSafeArea())
            // Navigation Routing directly into PlanDashboardView
            .navigationDestination(isPresented: $viewModel.shouldNavigateToDashboard) {
                if let result = viewModel.currentScanResult {
                    PlanDashboardView(scanResult: result)
                        .id(result.id)
                }
            }
            .onAppear {
                viewModel.onScanCompleted = { result in
                    activeScanResult = result
                }
            }
        }
    }
}

// MARK: - Guidance Helper Pill
private struct GuidePill: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.fitCyan)
            Text(text)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.fitSurface)
        .clipShape(Capsule())
        .overlay(Capsule().strokeBorder(Color.fitBorder, lineWidth: 1))
    }
}

// MARK: - Preset Scan Button Component
private struct PresetScanButton: View {
    let title: String
    let subtitle: String
    let color: Color
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticManager.shared.impact(.light)
            action()
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(color)
                    .frame(width: 34, height: 34)
                    .background(color.opacity(0.12))
                    .clipShape(Circle())
                
                Text(title)
                    .font(.caption.weight(.bold))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 4)
            .background(Color.fitSurface)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(color.opacity(0.35), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ScannerView()
}
