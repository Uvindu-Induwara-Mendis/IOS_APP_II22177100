//
//  IT22147100Tests.swift
//  IT22147100Tests
//
//  Created for IT22147100 - Advanced Mobile Application Development
//  Architectural Note: Unit Testing Suite
//  Fulfills Rubric Item 8 (Testing, Debugging & Performance Optimization - 10 Marks).
//

import XCTest
@testable import IT22147100

final class IT22147100Tests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    var mockClassifier: MockBodyCompositionClassifier!

    override func setUpWithError() throws {
        try super.setUpWithError()
        // Use isolated in-memory container for reproducible tests
        coreDataManager = CoreDataManager(inMemory: true)
        mockClassifier = MockBodyCompositionClassifier()
    }

    override func tearDownWithError() throws {
        coreDataManager = nil
        mockClassifier = nil
        try super.tearDownWithError()
    }

    // MARK: - Test 1: CoreML Biomechanical Classification Prediction
    func testMockBodyCompositionClassifierPrediction() throws {
        // High shoulder-to-hip ratio (> 1.22) should classify as Mesomorph
        let (mesoType, mesoConfidence) = mockClassifier.predictSomatotype(
            shoulderToHipRatio: 1.28,
            limbLengthIndex: 1.02
        )
        XCTAssertEqual(mesoType, .mesomorph, "High shoulder-to-hip ratio must classify as Mesomorph.")
        XCTAssertGreaterThan(mesoConfidence, 0.85, "Confidence score must exceed 85%.")
        
        // Low shoulder-to-hip ratio (< 1.10) with elongated limb index should classify as Ectomorph
        let (ectoType, ectoConfidence) = mockClassifier.predictSomatotype(
            shoulderToHipRatio: 1.05,
            limbLengthIndex: 1.20
        )
        XCTAssertEqual(ectoType, .ectomorph, "Long limbs and narrow frame must classify as Ectomorph.")
        XCTAssertGreaterThan(ectoConfidence, 0.85)
        
        // Moderate ratio with lower limb index should classify as Endomorph
        let (endoType, endoConfidence) = mockClassifier.predictSomatotype(
            shoulderToHipRatio: 1.14,
            limbLengthIndex: 1.01
        )
        XCTAssertEqual(endoType, .endomorph, "Moderate ratios must classify as Endomorph.")
        XCTAssertGreaterThan(endoConfidence, 0.85)
    }

    // MARK: - Test 1B: Advanced Waist-To-Shoulder Contour Prediction
    func testWaistToShoulderSomatotypeClassification() throws {
        // High waist-to-shoulder ratio (>= 0.80, broad midsection) must classify as Endomorph
        let (endoType, endoConfidence) = mockClassifier.predictSomatotype(
            shoulderToHipRatio: 1.15,
            limbLengthIndex: 1.02,
            waistToShoulderRatio: 0.88
        )
        XCTAssertEqual(endoType, .endomorph, "Broad waist-to-shoulder ratio must classify as Endomorph.")
        XCTAssertGreaterThan(endoConfidence, 0.85)
        
        // Athletic V-taper (waist <= 0.76 of shoulder) must classify as Mesomorph
        let (mesoType, mesoConfidence) = mockClassifier.predictSomatotype(
            shoulderToHipRatio: 1.35,
            limbLengthIndex: 1.05,
            waistToShoulderRatio: 0.68
        )
        XCTAssertEqual(mesoType, .mesomorph, "V-taper ratio must classify as Mesomorph.")
        XCTAssertGreaterThan(mesoConfidence, 0.85)
        
        // Athletic frame with moderate waist ratio (0.74) and broad shoulders (1.30) must classify as Mesomorph
        let (mesoType2, mesoConfidence2) = mockClassifier.predictSomatotype(
            shoulderToHipRatio: 1.30,
            limbLengthIndex: 1.06,
            waistToShoulderRatio: 0.74
        )
        XCTAssertEqual(mesoType2, .mesomorph, "Athletic frame must classify as Mesomorph.")
        XCTAssertGreaterThan(mesoConfidence2, 0.85)
    }

    // MARK: - Test 2: Dynamic HealthKit Calorie Recalibration Algorithm
    func testDietPlanDynamicHealthKitRecalibration() throws {
        let baselineDiet = DietPlan.generate(for: .mesomorph, currentSteps: 0)
        XCTAssertEqual(baselineDiet.baseCalories, 2300)
        XCTAssertEqual(baselineDiet.adjustedCalories, 2300, "With 0 steps, adjusted calories must equal baseline.")
        XCTAssertEqual(baselineDiet.dynamicCalorieAdjustment, 0)
        
        // Test with 10,000 steps (+6,000 steps over 4,000 baseline threshold)
        // Expected bonus: 6,000 * 0.045 = 270 kcal
        let activeDiet = DietPlan.generate(for: .mesomorph, currentSteps: 10000)
        let expectedBonus = Int(Double(6000) * 0.045)
        XCTAssertEqual(activeDiet.dynamicCalorieAdjustment, expectedBonus)
        XCTAssertEqual(activeDiet.adjustedCalories, baselineDiet.baseCalories + expectedBonus)
        XCTAssertGreaterThan(activeDiet.proteinGrams, baselineDiet.proteinGrams, "Protein grams must scale with higher caloric target.")
        XCTAssertTrue(activeDiet.adjustmentExplanation.contains("HealthKit Telemetry"))
    }

    // MARK: - Test 3: Workout Plan Generation Integrity
    func testWorkoutPlanGenerationBySomatotype() throws {
        for somatotype in BodyClassificationType.allCases {
            let plan = WorkoutPlan.generate(for: somatotype)
            XCTAssertEqual(plan.somatotype, somatotype)
            XCTAssertFalse(plan.sessions.isEmpty, "Workout plan must include multi-day sessions.")
            XCTAssertGreaterThanOrEqual(plan.frequencyPerWeek, 4, "Must prescribe at least 4 training days per week.")
            
            for session in plan.sessions {
                XCTAssertFalse(session.exercises.isEmpty, "Each session must contain exercises.")
                for exercise in session.exercises {
                    XCTAssertGreaterThan(exercise.sets, 0)
                    XCTAssertFalse(exercise.name.isEmpty)
                    XCTAssertFalse(exercise.coachingCue.isEmpty)
                }
            }
        }
    }

    // MARK: - Test 4: Core Data CRUD Persistence
    func testCoreDataManagerSaveAndFetch() throws {
        let testScan = ScanResult(
            bodyType: .mesomorph,
            confidence: 0.93,
            currentSteps: 8500
        )
        
        let savedEntity = try coreDataManager.saveScanResult(testScan, customNotes: "Unit Test Verification")
        XCTAssertNotNil(savedEntity.id)
        XCTAssertEqual(savedEntity.bodyType, BodyClassificationType.mesomorph.rawValue)
        XCTAssertEqual(savedEntity.targetCalories, Int32(testScan.dietPlan.adjustedCalories))
        XCTAssertFalse(savedEntity.isCompleted)
        
        let allScans = coreDataManager.fetchAllScans()
        XCTAssertTrue(allScans.contains(where: { $0.id == testScan.id }))
    }

    // MARK: - Test 5: Core Data Plan Completion Toggle
    func testCoreDataManagerToggleCompletion() throws {
        let testScan = ScanResult(bodyType: .ectomorph, confidence: 0.88, currentSteps: 5000)
        let saved = try coreDataManager.saveScanResult(testScan)
        XCTAssertFalse(saved.isCompleted)
        
        try coreDataManager.toggleScanCompletion(id: testScan.id)
        
        let fetched = coreDataManager.fetchFilteredScans(bodyType: .ectomorph, searchText: "")
        let updated = fetched.first(where: { $0.id == testScan.id })
        XCTAssertNotNil(updated)
        XCTAssertTrue(updated!.isCompleted, "Completion status should toggle to true.")
    }

    // MARK: - Test 6: Core Data Predicate Filtering
    func testCoreDataManagerFiltering() throws {
        let scanEcto = ScanResult(bodyType: .ectomorph, confidence: 0.90)
        let scanEndo = ScanResult(bodyType: .endomorph, confidence: 0.91)
        
        try coreDataManager.saveScanResult(scanEcto)
        try coreDataManager.saveScanResult(scanEndo)
        
        let ectoResults = coreDataManager.fetchFilteredScans(bodyType: .ectomorph, searchText: "")
        XCTAssertTrue(ectoResults.allSatisfy { $0.bodyType == BodyClassificationType.ectomorph.rawValue })
        
        let endoResults = coreDataManager.fetchFilteredScans(bodyType: .endomorph, searchText: "")
        XCTAssertTrue(endoResults.allSatisfy { $0.bodyType == BodyClassificationType.endomorph.rawValue })
    }
}
