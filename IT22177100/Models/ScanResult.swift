//
//  ScanResult.swift
//  FitVision
//
//  Created for IT22177100 - Advanced Mobile Application Development
//  Architectural Note: Scan Result Domain Model
//  Encapsulates the complete output of an on-device CoreML & Vision classification session,
//  linking the recognized somatotype, statistical confidence, and dynamic workout/diet blueprints.
//

import UIKit

struct ScanResult: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let timestamp: Date
    let bodyType: BodyClassificationType
    let confidence: Double
    var workoutPlan: WorkoutPlan
    var dietPlan: DietPlan
    var imageData: Data?
    var stepCountSnapshot: Int
    var isSavedToCoreData: Bool = false
    
    // MARK: - Formatted Confidence Percentage
    var confidencePercentageString: String {
        let percent = Int(confidence * 100.0)
        return "\(percent)%"
    }
    
    // MARK: - Convenience Initializer
    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        bodyType: BodyClassificationType,
        confidence: Double,
        imageData: Data? = nil,
        currentSteps: Int = 0
    ) {
        self.id = id
        self.timestamp = timestamp
        self.bodyType = bodyType
        self.confidence = confidence
        self.imageData = imageData
        self.stepCountSnapshot = currentSteps
        self.workoutPlan = WorkoutPlan.generate(for: bodyType)
        self.dietPlan = DietPlan.generate(for: bodyType, currentSteps: currentSteps)
        self.isSavedToCoreData = false
    }
    
    // MARK: - Preview Sample
    static var sampleMesomorph: ScanResult {
        ScanResult(
            bodyType: .mesomorph,
            confidence: 0.94,
            currentSteps: 7850
        )
    }
    
    static var sampleEctomorph: ScanResult {
        ScanResult(
            bodyType: .ectomorph,
            confidence: 0.89,
            currentSteps: 4200
        )
    }
    
    static var sampleEndomorph: ScanResult {
        ScanResult(
            bodyType: .endomorph,
            confidence: 0.91,
            currentSteps: 10450
        )
    }
}
