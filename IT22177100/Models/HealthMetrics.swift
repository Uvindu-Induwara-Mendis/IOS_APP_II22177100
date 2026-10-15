//
//  HealthMetrics.swift
//  FitVision
//
//  Created for IT22177100 - Advanced Mobile Application Development
//  Architectural Note: HealthKit Telemetry Domain Model
//  Encapsulates live step count, active energy burn, distance metrics,
//  and authorization state queried from Apple HealthKit.
//

import Foundation

// MARK: - Step Telemetry Data Source
enum StepDataSource: String, Equatable, Codable {
    case appleHealth = "Apple Health"
    case pedometer = "iPhone Motion Sensor"
    case fallbackBaseline = "Default Baseline"
    case simulated = "Simulated Override"
    
    var icon: String {
        switch self {
        case .appleHealth: return "heart.fill"
        case .pedometer: return "figure.walk.motion"
        case .fallbackBaseline: return "arrow.triangle.2.circlepath"
        case .simulated: return "slider.horizontal.3"
        }
    }
    
    var isLiveDevice: Bool {
        return self == .appleHealth || self == .pedometer
    }
}

struct HealthMetrics: Equatable {
    var dailySteps: Int
    var activeCaloriesBurned: Int
    var distanceMeters: Double
    var isAuthorized: Bool
    var lastSyncDate: Date
    var dataSource: StepDataSource
    var statusMessage: String?
    
    init(
        dailySteps: Int = 0,
        activeCaloriesBurned: Int = 0,
        distanceMeters: Double = 0.0,
        isAuthorized: Bool = false,
        lastSyncDate: Date = Date(),
        dataSource: StepDataSource = .fallbackBaseline,
        statusMessage: String? = nil
    ) {
        self.dailySteps = dailySteps
        self.activeCaloriesBurned = activeCaloriesBurned
        self.distanceMeters = distanceMeters
        self.isAuthorized = isAuthorized
        self.lastSyncDate = lastSyncDate
        self.dataSource = dataSource
        self.statusMessage = statusMessage
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
