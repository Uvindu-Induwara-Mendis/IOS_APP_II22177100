//
//  DietPlan.swift
//  FitVision
//
//  Created for IT22177100 - Advanced Mobile Application Development
//  Architectural Note: Dynamic Nutritional Engine & HealthKit Sync
//  Calculates baseline calories, macronutrient distribution (P/C/F),
//  and dynamically adjusts targets in real-time based on HealthKit step telemetry.
//

import Foundation

/// Individual meal suggestion with macronutrient breakdown
struct MealItem: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let title: String
    let timingDescription: String
    let description: String
    let calories: Int
    let proteinGrams: Int
    let carbsGrams: Int
    let fatGrams: Int
    let keyIngredients: [String]
}

/// Dynamic Diet Blueprint with real-time HealthKit step adaptation
struct DietPlan: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let somatotype: BodyClassificationType
    let baseCalories: Int
    var adjustedCalories: Int
    var proteinGrams: Int
    var carbsGrams: Int
    var fatGrams: Int
    var hydrationLiters: Double
    var stepCountSnapshot: Int
    var dynamicCalorieAdjustment: Int
    var adjustmentExplanation: String
    var meals: [MealItem]
    
    // MARK: - Factory with Dynamic HealthKit Adjustment
    static func generate(for somatotype: BodyClassificationType, currentSteps: Int = 0) -> DietPlan {
        let base = somatotype.baseCaloricBaseline
        
        // Dynamic step adjustment algorithm:
        // Baseline sedentary activity assumes ~4,000 steps.
        // For every 1,000 steps above 4,000, calculate ~45 kcal dynamic energy expenditure.
        let dynamicBurn: Int
        let explanation: String
        
        if currentSteps > 4000 {
            let additionalSteps = currentSteps - 4000
            dynamicBurn = Int(Double(additionalSteps) * 0.045)
            explanation = "HealthKit Telemetry: +\(dynamicBurn) kcal added from \(currentSteps.formatted()) recorded steps today."
        } else if currentSteps > 0 {
            dynamicBurn = 0
            explanation = "HealthKit Telemetry: \(currentSteps.formatted()) steps recorded. Baseline metabolic caloric target maintained."
        } else {
            dynamicBurn = 0
            explanation = "HealthKit Telemetry: Awaiting step activity. Displaying standard baseline caloric target."
        }
        
        let totalCalories = base + dynamicBurn
        
        // Calculate grams based on caloric densities:
        // Protein: 4 kcal/g, Carbs: 4 kcal/g, Fat: 9 kcal/g
        let proteinCal = Double(totalCalories) * somatotype.proteinRatio
        let carbsCal = Double(totalCalories) * somatotype.carbsRatio
        let fatCal = Double(totalCalories) * somatotype.fatRatio
        
        let proteinG = Int(proteinCal / 4.0)
        let carbsG = Int(carbsCal / 4.0)
        let fatG = Int(fatCal / 9.0)
        
        // Dynamic hydration calculation (base + 0.15L per 2,000 steps)
        let extraHydration = Double(currentSteps / 2000) * 0.15
        let totalHydration = ((somatotype.recommendedHydrationLiters + extraHydration) * 10).rounded() / 10
        
        let meals = generateMeals(for: somatotype, totalCalories: totalCalories)
        
        return DietPlan(
            somatotype: somatotype,
            baseCalories: base,
            adjustedCalories: totalCalories,
            proteinGrams: proteinG,
            carbsGrams: carbsG,
            fatGrams: fatG,
            hydrationLiters: totalHydration,
            stepCountSnapshot: currentSteps,
            dynamicCalorieAdjustment: dynamicBurn,
            adjustmentExplanation: explanation,
            meals: meals
        )
    }
    
    // MARK: - Meal Suggestions by Somatotype
    private static func generateMeals(for somatotype: BodyClassificationType, totalCalories: Int) -> [MealItem] {
        switch somatotype {
        case .ectomorph:
            return [
                MealItem(
                    title: "Calorie-Dense Power Breakfast",
                    timingDescription: "Within 60 mins of waking",
                    description: "Steel-cut oatmeal prepared with whole milk, topped with banana, natural peanut butter, and whey protein isolate.",
                    calories: Int(Double(totalCalories) * 0.28),
                    proteinGrams: 42,
                    carbsGrams: 85,
                    fatGrams: 20,
                    keyIngredients: ["Steel Cut Oats", "Peanut Butter", "Banana", "Whey Protein", "Whole Milk"]
                ),
                MealItem(
                    title: "Lean Mass Builder Lunch",
                    timingDescription: "Midday Fueling Window",
                    description: "Grilled chicken breast, jasmine rice with olive oil drizzle, avocado slices, and steamed broccoli.",
                    calories: Int(Double(totalCalories) * 0.32),
                    proteinGrams: 52,
                    carbsGrams: 90,
                    fatGrams: 18,
                    keyIngredients: ["Chicken Breast", "Jasmine Rice", "Avocado", "Extra Virgin Olive Oil"]
                ),
                MealItem(
                    title: "Pre-Workout Anabolic Primer",
                    timingDescription: "90 mins before training",
                    description: "Rice cakes with honey, almond butter, and BCAAs or light whey shake for sustained glycogen availability.",
                    calories: Int(Double(totalCalories) * 0.15),
                    proteinGrams: 20,
                    carbsGrams: 55,
                    fatGrams: 10,
                    keyIngredients: ["Rice Cakes", "Honey", "Almond Butter"]
                ),
                MealItem(
                    title: "Overnight Hypertrophy Recovery Dinner",
                    timingDescription: "Evening Post-Training",
                    description: "Baked Atlantic salmon filet, baked sweet potato with cinnamon, and mixed dark leafy greens.",
                    calories: Int(Double(totalCalories) * 0.25),
                    proteinGrams: 46,
                    carbsGrams: 60,
                    fatGrams: 22,
                    keyIngredients: ["Atlantic Salmon", "Sweet Potato", "Spinach", "Asparagus"]
                )
            ]
            
        case .mesomorph:
            return [
                MealItem(
                    title: "Athletic Performance Breakfast",
                    timingDescription: "07:30 - 08:30 AM",
                    description: "3 whole pasture-raised eggs scrambled with spinach, 2 slices sprouted sourdough toast, and half an avocado.",
                    calories: Int(Double(totalCalories) * 0.26),
                    proteinGrams: 38,
                    carbsGrams: 45,
                    fatGrams: 20,
                    keyIngredients: ["Pasture Eggs", "Sourdough Bread", "Avocado", "Spinach"]
                ),
                MealItem(
                    title: "Nutrient Partitioning Lunch",
                    timingDescription: "12:30 - 01:30 PM",
                    description: "Grass-fed lean beef sirloin, sweet potato cubes, and roasted Mediterranean vegetables with olive oil.",
                    calories: Int(Double(totalCalories) * 0.34),
                    proteinGrams: 55,
                    carbsGrams: 65,
                    fatGrams: 22,
                    keyIngredients: ["Grass-Fed Beef", "Sweet Potato", "Bell Peppers", "Olive Oil"]
                ),
                MealItem(
                    title: "Pre/Post Training Fuel",
                    timingDescription: "Around Workout Session",
                    description: "Greek yogurt bowl with organic berries, raw pumpkin seeds, and a scoop of hydrolyzed whey.",
                    calories: Int(Double(totalCalories) * 0.16),
                    proteinGrams: 30,
                    carbsGrams: 35,
                    fatGrams: 8,
                    keyIngredients: ["0% Greek Yogurt", "Blueberries", "Pumpkin Seeds"]
                ),
                MealItem(
                    title: "Repair & Muscle Protein Synthesis Dinner",
                    timingDescription: "07:30 - 08:30 PM",
                    description: "Pan-seared cod or turkey tenderloin, quinoa pilaf, and steamed green beans with garlic butter.",
                    calories: Int(Double(totalCalories) * 0.24),
                    proteinGrams: 48,
                    carbsGrams: 50,
                    fatGrams: 16,
                    keyIngredients: ["Wild Cod", "Quinoa", "Green Beans", "Grass-Fed Butter"]
                )
            ]
            
        case .endomorph:
            return [
                MealItem(
                    title: "Metabolic Kickstart (Low Glycemic)",
                    timingDescription: "Morning (or Post-Fast)",
                    description: "Spinach, mushroom, and feta egg-white & whole egg frittata with a side of fresh berries.",
                    calories: Int(Double(totalCalories) * 0.25),
                    proteinGrams: 40,
                    carbsGrams: 20,
                    fatGrams: 18,
                    keyIngredients: ["Whole Eggs & Whites", "Baby Spinach", "Feta Cheese", "Blackberries"]
                ),
                MealItem(
                    title: "Lean Protein Satiety Bowl",
                    timingDescription: "Midday Fueling Window",
                    description: "Grilled lemon-herb chicken breast over cauliflower rice and mixed greens with walnuts and flaxseed dressing.",
                    calories: Int(Double(totalCalories) * 0.35),
                    proteinGrams: 55,
                    carbsGrams: 28,
                    fatGrams: 24,
                    keyIngredients: ["Chicken Breast", "Cauliflower Rice", "Walnuts", "Extra Virgin Olive Oil"]
                ),
                MealItem(
                    title: "Mid-Afternoon Thermogenic Snack",
                    timingDescription: "03:30 - 04:00 PM",
                    description: "Raw celery and cucumber sticks with homemade hummus and hard-boiled egg whites.",
                    calories: Int(Double(totalCalories) * 0.12),
                    proteinGrams: 16,
                    carbsGrams: 18,
                    fatGrams: 8,
                    keyIngredients: ["Hummus", "Celery", "Cucumber", "Egg Whites"]
                ),
                MealItem(
                    title: "Anti-Inflammatory Evening Meal",
                    timingDescription: "07:00 - 08:00 PM",
                    description: "Wild salmon filet with roasted zucchini, asparagus, and a small side of brown rice or lentils.",
                    calories: Int(Double(totalCalories) * 0.28),
                    proteinGrams: 46,
                    carbsGrams: 35,
                    fatGrams: 20,
                    keyIngredients: ["Wild Salmon", "Zucchini", "Asparagus", "Brown Rice"]
                )
            ]
        }
    }
}
