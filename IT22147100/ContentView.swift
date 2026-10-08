//
//  ContentView.swift
//  FitVision
//
//  Created for IT22147100 - Advanced Mobile Application Development
//  Architectural Note: Root Application Coordinator & Navigation Shell
//  Fulfills Rubric Items 1 (Onboarding Gate), 4 (Navigation), and 7 (Visual Branding).
//
//  DESIGN DECISION & TECHNICAL REPORT SUMMARY:
//  1. State-Driven Architectural Gate: If the user has not accepted the mandatory medical
//     and biometric disclosures, the app strictly constrains them to OnboardingView.
//  2. Modern TabView Navigation: Houses the primary functional domains (Scanner, AI Dashboard,
//     and Core Data History Vault) with custom SF Symbols and tint theming.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @State private var selectedTab: Int = 0
    @State private var activeScanResult: ScanResult = ScanResult.sampleMesomorph
    
    var body: some View {
        Group {
            if !onboardingViewModel.hasAcceptedMedicalDisclaimer {
                OnboardingView(viewModel: onboardingViewModel)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            } else {
                TabView(selection: $selectedTab) {
                    // Tab 1: The Scanner (Home)
                    ScannerView(activeScanResult: $activeScanResult, selectedTab: $selectedTab)
                        .tabItem {
                            Label("Scanner", systemImage: "viewfinder.circle.fill")
                        }
                        .tag(0)
                    
                    // Tab 2: AI Plan Dashboard
                    NavigationStack {
                        PlanDashboardView(scanResult: activeScanResult)
                            .id(activeScanResult.id)
                    }
                    .tabItem {
                        Label("AI Blueprint", systemImage: "sparkles.square.filled.on.square")
                    }
                    .tag(1)
                    
                    // Tab 3: Core Data History Vault
                    HistoryView()
                        .tabItem {
                            Label("History", systemImage: "clock.arrow.circlepath")
                        }
                        .tag(2)
                }
                .tint(Color.fitEmerald)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: onboardingViewModel.hasAcceptedMedicalDisclaimer)
        .onAppear {
            loadLatestScanIfAvailable()
            
            // Trigger HealthKit authorization request on launch
            Task {
                await HealthKitService.shared.requestAuthorization()
            }
        }
    }
    
    private func loadLatestScanIfAvailable() {
        let scans = CoreDataManager.shared.fetchAllScans()
        if let latest = scans.first(where: { $0.imageData != nil }) ?? scans.first {
            self.activeScanResult = ScanResult(
                id: latest.id ?? UUID(),
                timestamp: latest.safeTimestamp,
                bodyType: latest.safeBodyType,
                confidence: latest.confidence,
                imageData: latest.imageData,
                currentSteps: Int(latest.stepCountSnapshot)
            )
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, CoreDataManager.preview.viewContext)
}
