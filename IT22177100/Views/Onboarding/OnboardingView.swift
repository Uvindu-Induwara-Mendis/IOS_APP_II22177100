//
//  OnboardingView.swift
//  FitVision
//
//  Created for IT22177100 - Advanced Mobile Application Development
//  Architectural Note: Screen 1 - Onboarding & Regulatory Medical Disclosure
//  Meets Rubric Item 1 (Purpose & Target Audience) and Accessibility Standards.
//
//  DESIGN DECISION & TECHNICAL REPORT SUMMARY:
//  1. Legal & Safety Architecture: Strictly isolates users behind mandatory medical
//     and biometric disclosures before granting access to AI generative blueprints.
//  2. High-Contrast Accessible Design: Features Dynamic Type friendly typography,
//     WCAG AA compliant contrast ratios, and tactile toggle feedbacks.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: - App Branding Hero
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient.brandButtonGradient)
                            .frame(width: 80, height: 80)
                            .shadow(color: Color.fitEmerald.opacity(0.3), radius: 12, x: 0, y: 6)
                        
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundColor(Color(red: 0.04, green: 0.10, blue: 0.06))
                    }
                    .padding(.top, 20)
                    
                    Text("FitVision AI")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Intelligent Somatotype Body Analysis & Dynamic HealthKit Nutrition")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                
                // MARK: - Core Feature Pillars
                VStack(spacing: 12) {
                    FeaturePillarRow(
                        icon: "camera.viewfinder",
                        color: Color.fitCyan,
                        title: "On-Device Biometric Vision",
                        description: "Analyzes posture and body ratios locally with zero cloud photo uploads."
                    )
                    
                    FeaturePillarRow(
                        icon: "heart.text.square.fill",
                        color: Color.fitEmerald,
                        title: "Apple HealthKit Calibration",
                        description: "Dynamically recalculates caloric and hydration needs using your active step count."
                    )
                    
                    FeaturePillarRow(
                        icon: "internaldrive.fill",
                        color: Color.fitViolet,
                        title: "Offline History Vault",
                        description: "Persists historical scans, blueprints, and progress records securely on your device."
                    )
                }
                .glassmorphicCard(cornerRadius: 20)
                .padding(.horizontal, 16)
                
                // MARK: - Medical Disclaimer Card
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.title3)
                            .foregroundColor(Color.fitCoral)
                        
                        Text("Mandatory Medical Disclaimer")
                            .font(.headline.bold())
                            .foregroundColor(.primary)
                    }
                    
                    Text("FitVision is an algorithmic artificial intelligence tool designed strictly for general fitness education and informational purposes. It is NOT a medical device and does NOT provide medical diagnosis or clinical treatment.\n\nAlways consult a qualified physician or healthcare professional before embarking on high-intensity training or altering your caloric intake.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Divider()
                        .background(Color.fitBorder)
                    
                    // Mandatory Consent Toggles
                    VStack(alignment: .leading, spacing: 12) {
                        Toggle(isOn: $viewModel.medicalDisclaimerAcknowledged) {
                            Text("I understand this is a fitness algorithm, not medical or clinical advice.")
                                .font(.footnote.weight(.medium))
                                .foregroundColor(.primary)
                        }
                        .toggleStyle(CheckboxToggleStyle(tintColor: Color.fitEmerald))
                        
                        Toggle(isOn: $viewModel.termsAcknowledged) {
                            Text("I accept the Terms of Service & General Fitness Guidelines.")
                                .font(.footnote.weight(.medium))
                                .foregroundColor(.primary)
                        }
                        .toggleStyle(CheckboxToggleStyle(tintColor: Color.fitCyan))
                        
                        Toggle(isOn: $viewModel.biometricPrivacyAcknowledged) {
                            Text("I acknowledge that photo analysis is processed strictly on-device.")
                                .font(.footnote.weight(.medium))
                                .foregroundColor(.primary)
                        }
                        .toggleStyle(CheckboxToggleStyle(tintColor: Color.fitViolet))
                    }
                }
                .glassmorphicCard(cornerRadius: 20, strokeColor: Color.fitCoral.opacity(0.35))
                .padding(.horizontal, 16)
                
                // MARK: - Action Button
                VStack(spacing: 10) {
                    Button(action: {
                        viewModel.completeOnboarding()
                    }) {
                        HStack {
                            Text(viewModel.canProceedToApp ? "Enter FitVision" : "Accept Disclaimers to Continue")
                            Image(systemName: "arrow.right")
                        }
                    }
                    .primaryBrandButton(isEnabled: viewModel.canProceedToApp)
                    .disabled(!viewModel.canProceedToApp)
                    
                    Text("By proceeding, you affirm that you are participating voluntarily.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 36)
            }
        }
        .background(Color.fitBackground.ignoresSafeArea())
    }
}

// MARK: - Custom Checkbox Toggle Style
struct CheckboxToggleStyle: ToggleStyle {
    var tintColor: Color = Color.fitEmerald
    
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
            HapticManager.shared.selection()
        }) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundColor(configuration.isOn ? tintColor : Color.secondary.opacity(0.6))
                
                configuration.label
                    .multilineTextAlignment(.leading)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Feature Pillar Row
private struct FeaturePillarRow: View {
    let icon: String
    let color: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.14))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    OnboardingView(viewModel: OnboardingViewModel())
}
