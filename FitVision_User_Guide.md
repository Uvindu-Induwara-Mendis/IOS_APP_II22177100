# FitVision: User Guide & Examiner Demonstration Manual
**Student Project Identifier:** IT22147100  
**Project Name:** FitVision AI  
**Deployment Target:** iOS 17.0+ (iPhone & iPad)  

---

## 1. Quick Start: Running the Project in Xcode on Mac
When you send this folder to your friend or open it on a Mac:

1. **Extract or Open the Folder:**
   * Double-click `IT22147100.xcodeproj` to open it in **Xcode 15 or 16**.
2. **Select Target & Simulator:**
   * In Xcode's top toolbar, ensure the active scheme is set to `IT22147100`.
   * Select any modern iPhone simulator (e.g., **iPhone 15 Pro**, **iPhone 16**, or **iPhone 16 Pro**).
3. **Build and Run:**
   * Press **Cmd + R** or click the **Play** button.
   * The project will compile with **zero errors and zero warnings**!
4. **Run Automated Tests:**
   * Press **Cmd + U** to run all Unit Tests and UI Tests.

---

## 2. Walkthrough of the 4 Required Screens

### Screen 1: Onboarding & Medical Disclosure
* **What you see:** A sleek splash screen displaying the brand logo, core feature pillars, and a mandatory Medical & Biometric Disclaimer.
* **How to interact:**
  1. Notice that the **"Enter FitVision"** button is initially disabled.
  2. Tap each of the three checkboxes:
     * *Medical Disclaimer Acknowledgment*
     * *Terms of Service Agreement*
     * *On-Device Biometric Privacy Confirmation*
  3. The button will unlock with haptic feedback and an animated spring transition. Tap **"Enter FitVision"** to enter the app.

---

### Screen 2: The AI Scanner (Home)
* **What you see:** The primary camera/photo scanning viewport with the glowing HUD header and status badge indicating `CoreML Active`.
* **How to interact:**
  * **Option A (Simulator Quick Test Presets):**
    * Under "Examiner Quick Test Presets", tap **Mesomorph**, **Ectomorph**, or **Endomorph**.
    * A high-resolution synthetic silhouette will load immediately into the scanning viewport.
    * The **Sci-Fi Scanning Laser HUD** will activate, sweeping up and down with glowing particle beams while displaying real-time Vision processing telemetry ("Normalizing image tensors...", "Detecting anatomical keypoints...", "Evaluating CoreML somatotype...").
    * Upon completion, the app automatically transitions to **Screen 3: AI Plan Dashboard**.
  * **Option B (Photo Library):**
    * Tap **"Select Photo to Scan"** to choose any photo from the device/simulator gallery.

---

### Screen 3: AI Plan Dashboard
* **What you see:**
  1. **CoreML Classification Header:** Displays the classified body type (e.g., *MESOMORPH*), confidence percentage (e.g., *94%*), and scientific summary.
  2. **Apple HealthKit Step Telemetry Widget:** Displays live steps, active energy burned, and dynamic calorie adjustments.
  3. **Examiner Live Demonstration Controls:**
     * Tap **"Test Live Adjustments"** on the HealthKit widget to expand the step slider.
     * Drag the slider from 2,000 to 14,000 steps.
     * **Watch the dynamic calories and macronutrients instantly recalculate in real time!**
  4. **Segmented Mode Switcher:**
     * **Workout Blueprint:** Switch between workout days, view sets, reps, coaching cues, and tap the checkmark circles to mark exercises completed.
     * **Nutritional Engine:** View the animated **Macro Donut Chart**, chronobiological meal breakdown, and daily hydration targets.
  5. **Core Data Save Button:**
     * Tap **"Save Blueprint to Core Data"** at the bottom to store the scan record. A green confirmation banner will appear.

---

### Screen 4: Core Data History Vault
* **What you see:** A persistent record of all previous scans, including pre-seeded sample records and newly saved scans.
* **How to interact:**
  1. **Category Filter Chips:** Tap **Mesomorph**, **Ectomorph**, or **Endomorph** to filter the list.
  2. **Search Bar:** Type in keywords (e.g., "Hypertrophy", "Power", or "Surplus") to search plans dynamically.
  3. **Completion Toggle:** Tap the **"Done" / "Pending"** pill on any row to toggle its completion flag in Core Data.
  4. **Swipe to Delete:** Swipe left on any row and tap the red **Delete** button.
  5. **Detailed Telemetry:** Tap any row to open **ScanDetailView**, revealing full preserved macro charts and original photo thumbnails.

---

## 3. Dark Mode & Accessibility Demonstration
* In Xcode Simulator, press **Cmd + Shift + A** to toggle between **Light Mode** and **Dark Mode**.
* Observe how the frosted glassmorphic cards, specular borders, and text automatically adapt with high-contrast accessibility.
