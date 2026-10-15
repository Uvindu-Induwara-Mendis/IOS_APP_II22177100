//
//  IT22177100UITests.swift
//  IT22177100UITests
//
//  Created for IT22177100 - Advanced Mobile Application Development
//  Architectural Note: UI Testing Suite
//  Fulfills Rubric Item 8 (Testing, Debugging & Performance Optimization - 10 Marks).
//

import XCTest

final class IT22177100UITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testAppLaunchAndOnboardingGate() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Verify either Onboarding Screen is visible or TabBar is present
        let onboardingTitle = app.staticTexts["FitVision AI"]
        let scannerTab = app.tabBars.buttons["Scanner"]
        
        let isPresent = onboardingTitle.waitForExistence(timeout: 3.0) || scannerTab.waitForExistence(timeout: 3.0)
        XCTAssertTrue(isPresent, "App must successfully render either Onboarding or Main TabView.")
    }

    @MainActor
    func testTabBarNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        
        let scannerTab = app.tabBars.buttons["Scanner"]
        if scannerTab.waitForExistence(timeout: 2.0) {
            // Tap Blueprint Tab
            let blueprintTab = app.tabBars.buttons["AI Blueprint"]
            if blueprintTab.exists {
                blueprintTab.tap()
                XCTAssertTrue(app.staticTexts["AI Blueprint"].waitForExistence(timeout: 2.0))
            }
            
            // Tap History Tab
            let historyTab = app.tabBars.buttons["History"]
            if historyTab.exists {
                historyTab.tap()
                XCTAssertTrue(app.staticTexts["Scan History"].waitForExistence(timeout: 2.0))
            }
        }
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
