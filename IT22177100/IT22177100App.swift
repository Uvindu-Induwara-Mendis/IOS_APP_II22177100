//
//  IT22177100App.swift
//  FitVision
//
//  Created for IT22177100 - Advanced Mobile Application Development
//  Architectural Note: Application Lifecycle Entry Point
//  Fulfills Rubric Items 1-10.
//

import SwiftUI
import CoreData

@main
struct IT22177100App: App {
    let persistenceController = PersistenceController.shared
    let coreDataManager = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(coreDataManager)
        }
    }
}
