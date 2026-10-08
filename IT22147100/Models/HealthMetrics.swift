//
//  HealthMetrics.swift
//  FitVision
//
//  Created for IT22147100 - Advanced Mobile Application Development
//  Architectural Note: HealthKit Telemetry Domain Model
//  Encapsulates live step count, active energy burn, distance metrics,
//  and authorization state queried from Apple HealthKit.
//

import Foundation

struct HealthMetrics: Equatable {
    var dailySteps: Int
    var activeCaloriesBurned: Int
    var distanceMeters: Double
    var isAuthorized: Bool
    var lastSyncDate: Date
    
    init(
        dailySteps: Int = 0,
        activeCaloriesBurned: Int = 0,
        distanceMeters: Double = 0.0,
        isAuthorized: Bool = false,
        lastSyncDate: Date = Date()
    ) {
        self.dailySteps = dailySteps
        self.activeCaloriesBurned = activeCaloriesBurned
        self.distanceMeters = distanceMeters
        self.isAuthorized = isAuthorized
        self.lastSyncDate = lastSyncDate
    }
    
    // MARK: - Formatted Output Helpers
    var distanceKilometersFormatted: String {
        let km = distanceMeters / 1000.0
        return String(format: "%.2f km", km)
    }
    
    var stepsFormatted: String {
        dailySteps.formatted()
    }
    
    var dynamicBurnExplanation: String {
        if dailySteps > 4000 {
            let bonus = Int(Double(dailySteps - 4000) * 0.045)
            return "+\(bonus) kcal dynamic energy allowance earned today from \(stepsFormatted) steps."
        } else {
            return "Metabolic baseline active. Reach 5,000+ steps to unlock dynamic carbohydrate allowances."
        }
    }
}
