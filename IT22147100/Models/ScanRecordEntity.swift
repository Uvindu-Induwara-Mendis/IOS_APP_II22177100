//
//  ScanRecordEntity.swift
//  FitVision
//
//  Created for IT22147100 - Advanced Mobile Application Development
//  Architectural Note: Core Data Managed Object Subclass
//  Matches the Core Data model 'IT22147100.xcdatamodeld' schema.
//  Configured with Manual/None code generation to avoid symbol collisions
//  while providing full type safety and custom convenience helpers.
//

import Foundation
import CoreData

@objc(ScanRecordEntity)
public class ScanRecordEntity: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var imageData: Data?
    @NSManaged public var bodyType: String?
    @NSManaged public var confidence: Double
    @NSManaged public var planTitle: String?
    @NSManaged public var targetCalories: Int32
    @NSManaged public var workoutDays: Int32
    @NSManaged public var planNotes: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var stepCountSnapshot: Int32
    @NSManaged public var proteinGrams: Int32
    @NSManaged public var carbsGrams: Int32
    @NSManaged public var fatGrams: Int32
    @NSManaged public var trainingSplit: String?
    
    // MARK: - Safe Type Accessors
    var safeBodyType: BodyClassificationType {
        if let bodyType = bodyType, let type = BodyClassificationType(rawValue: bodyType) {
            return type
        }
        return .mesomorph
    }
    
    public var safeTimestamp: Date {
        timestamp ?? Date()
    }
    
    public var safePlanTitle: String {
        planTitle ?? "AI Fitness Blueprint"
    }
    
    // MARK: - Fetch Request Helper
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScanRecordEntity> {
        let request = NSFetchRequest<ScanRecordEntity>(entityName: "ScanRecordEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ScanRecordEntity.timestamp, ascending: false)]
        return request
    }
}
