//
//  DailyCheckInEntity.swift
//  FitVision
//
//  Created for IT22177100 - Advanced Mobile Application Development
//  Architectural Note: Core Data Daily Tracking Entity
//  Persists user daily compliance, step logs, water intake, and workout completion flags.
//

import Foundation
import CoreData

@objc(DailyCheckInEntity)
public class DailyCheckInEntity: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var stepCount: Int32
    @NSManaged public var waterIntakeLiters: Double
    @NSManaged public var caloriesBurned: Int32
    @NSManaged public var completedWorkout: Bool
    @NSManaged public var notes: String?
    
    // MARK: - Safe Accessors
    public var safeDate: Date {
        date ?? Date()
    }
    
    // MARK: - Fetch Request Helper
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyCheckInEntity> {
        let request = NSFetchRequest<DailyCheckInEntity>(entityName: "DailyCheckInEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DailyCheckInEntity.date, ascending: false)]
        return request
    }
}
