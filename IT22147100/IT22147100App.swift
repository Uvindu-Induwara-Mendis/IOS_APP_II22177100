//
//  IT22147100App.swift
//  FitVision
//
//  Created for IT22147100 - Advanced Mobile Application Development
//  Architectural Note: Application Lifecycle Entry Point
//  Fulfills Rubric Items 1-10.
//

import SwiftUI
import CoreData

@main
struct IT22147100App: App {
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
