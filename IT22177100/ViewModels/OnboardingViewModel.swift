//
//  OnboardingViewModel.swift
//  FitVision
//
//  Created for IT22177100 - Advanced Mobile Application Development
//  Architectural Note: MVVM ViewModel for Screen 1 (Onboarding & Legal)
//  Fulfills Rubric Item 1 (Purpose & Target Audience) and Screen 1 Requirements.
//
//  DESIGN DECISION & TECHNICAL REPORT SUMMARY:
//  1. Mandatory Medical Disclosure: Regulatory compliance requiring explicit opt-in
//     before exposing AI-generated physical training and caloric guidance.
//  2. Persistent Consent: State is stored in UserDefaults so returning users bypass
//     onboarding, while providing a diagnostic reset trigger for demonstration/grading.
//

import SwiftUI
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var hasAcceptedMedicalDisclaimer: Bool {
        didSet {
            UserDefaults.standard.set(hasAcceptedMedicalDisclaimer, forKey: "hasAcceptedMedicalDisclaimer")
        }
    }
    
    @Published var medicalDisclaimerAcknowledged: Bool = false
    @Published var termsAcknowledged: Bool = false
    @Published var biometricPrivacyAcknowledged: Bool = false
    
    // MARK: - Validation Gate
    var canProceedToApp: Bool {
        medicalDisclaimerAcknowledged && termsAcknowledged && biometricPrivacyAcknowledged
    }
    
    init() {
        self.hasAcceptedMedicalDisclaimer = UserDefaults.standard.bool(forKey: "hasAcceptedMedicalDisclaimer")
    }
    
    // MARK: - Actions
    func completeOnboarding() {
        guard canProceedToApp else { return }
        HapticManager.shared.notification(.success)
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            self.hasAcceptedMedicalDisclaimer = true
        }
    }
    
    func resetOnboardingForDemo() {
        UserDefaults.standard.set(false, forKey: "hasAcceptedMedicalDisclaimer")
        withAnimation {
            self.hasAcceptedMedicalDisclaimer = false
            self.medicalDisclaimerAcknowledged = false
            self.termsAcknowledged = false
            self.biometricPrivacyAcknowledged = false
        }
    }
}
