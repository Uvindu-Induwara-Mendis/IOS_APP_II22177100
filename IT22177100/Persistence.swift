//
//  Persistence.swift
//  FitVision
//
//  Created for IT22177100 - Advanced Mobile Application Development
//  Architectural Note: Core Data Persistence Controller Bridge
//  Supplies standard container references, preview environments,
//  and links directly to CoreDataManager.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Seed preview records
        let sample = ScanRecordEntity(context: viewContext)
        sample.id = UUID()
        sample.timestamp = Date()
        sample.bodyType = BodyClassificationType.mesomorph.rawValue
        sample.confidence = 0.94
        sample.planTitle = "Preview Athletic Blueprint"
        sample.targetCalories = 2350
        sample.workoutDays = 4
        sample.planNotes = "Preview context initialized with sample somatotype metrics."
        sample.isCompleted = false
        sample.stepCountSnapshot = 8200
        sample.proteinGrams = 175
        sample.carbsGrams = 250
        sample.fatGrams = 65
        sample.trainingSplit = "Upper / Lower Split"
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Preview context save error: \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = CoreDataManager.shared.container
    }
}
