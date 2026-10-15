//
//  WorkoutPlan.swift
//  FitVision
//
//  Created for IT22177100 - Advanced Mobile Application Development
//  Architectural Note: Workout Blueprint Domain Models
//  Defines structured workout routines, sets, reps, coaching notes,
//  and generator factory tailored for each CoreML body classification.
//

import Foundation

/// Individual exercise entry with sets, reps, rest period, and coaching cues
struct ExerciseItem: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let name: String
    let targetMuscle: String
    let sets: Int
    let reps: String
    let restSeconds: Int
    let equipment: String
    let coachingCue: String
    var isCompleted: Bool = false
}

/// A structured workout session for a given day
struct WorkoutSession: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let dayNumber: Int
    let title: String
    let focusArea: String
    let estimatedDurationMinutes: Int
    var exercises: [ExerciseItem]
}

/// Complete AI-generated Workout Plan tailored to body type
struct WorkoutPlan: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let somatotype: BodyClassificationType
    let title: String
    let splitDescription: String
    let frequencyPerWeek: Int
    let primaryObjective: String
    var sessions: [WorkoutSession]
    
    // MARK: - Factory Generation
    static func generate(for somatotype: BodyClassificationType) -> WorkoutPlan {
        switch somatotype {
        case .ectomorph:
            return WorkoutPlan(
                somatotype: .ectomorph,
                title: "Hypertrophy & Mass Acceleration",
                splitDescription: "Push / Pull / Legs Hypertrophy Split",
                frequencyPerWeek: 4,
                primaryObjective: "Maximize mechanical tension and myofibrillar hypertrophy with controlled tempo.",
                sessions: [
                    WorkoutSession(
                        dayNumber: 1,
                        title: "Push Focus: Chest, Shoulders & Triceps",
                        focusArea: "Anterior Kinetic Chain",
                        estimatedDurationMinutes: 50,
                        exercises: [
                            ExerciseItem(name: "Incline Barbell Bench Press", targetMuscle: "Upper Chest", sets: 4, reps: "8-10", restSeconds: 90, equipment: "Barbell & Bench", coachingCue: "Slow 3-second eccentric lower; drive through heels."),
                            ExerciseItem(name: "Dumbbell Overhead Shoulder Press", targetMuscle: "Deltoids", sets: 3, reps: "10-12", restSeconds: 75, equipment: "Dumbbells", coachingCue: "Avoid arching lower back; brace core throughout."),
                            ExerciseItem(name: "Cable Tricep Rope Pushdown", targetMuscle: "Triceps Lateral Head", sets: 3, reps: "12-15", restSeconds: 60, equipment: "Cable Stack", coachingCue: "Flare rope outward at full elbow extension."),
                            ExerciseItem(name: "Lateral Dumbbell Raises", targetMuscle: "Lateral Deltoids", sets: 4, reps: "15", restSeconds: 60, equipment: "Dumbbells", coachingCue: "Lead with elbows, keep pinkies slightly elevated.")
                        ]
                    ),
                    WorkoutSession(
                        dayNumber: 2,
                        title: "Pull Focus: Back, Rear Delts & Biceps",
                        focusArea: "Posterior Chain",
                        estimatedDurationMinutes: 50,
                        exercises: [
                            ExerciseItem(name: "Neutral-Grip Lat Pulldowns", targetMuscle: "Latissimus Dorsi", sets: 4, reps: "8-10", restSeconds: 90, equipment: "Cable Machine", coachingCue: "Depress scapula before initiating elbow pull."),
                            ExerciseItem(name: "Chest-Supported Dumbbell Rows", targetMuscle: "Rhomboids & Mid-Traps", sets: 3, reps: "10-12", restSeconds: 75, equipment: "Incline Bench", coachingCue: "Squeeze shoulder blades together for 1 full second."),
                            ExerciseItem(name: "Incline Dumbbell Bicep Curls", targetMuscle: "Biceps Brachii", sets: 3, reps: "10-12", restSeconds: 60, equipment: "Dumbbells", coachingCue: "Maintain arm angle behind torso for maximal long-head stretch."),
                            ExerciseItem(name: "Face Pulls with External Rotation", targetMuscle: "Rotator Cuff & Rear Delts", sets: 4, reps: "15", restSeconds: 60, equipment: "Cable Stack", coachingCue: "Pull thumbs toward temples; strengthen posture.")
                        ]
                    ),
                    WorkoutSession(
                        dayNumber: 3,
                        title: "Legs & Core Foundation",
                        focusArea: "Lower Body Force Production",
                        estimatedDurationMinutes: 55,
                        exercises: [
                            ExerciseItem(name: "Barbell Back Squat", targetMuscle: "Quadriceps & Glutes", sets: 4, reps: "6-8", restSeconds: 120, equipment: "Squat Rack", coachingCue: "Descend below parallel; maintain neutral spine."),
                            ExerciseItem(name: "Romanian Deadlift (RDL)", targetMuscle: "Hamstrings & Glutes", sets: 3, reps: "8-10", restSeconds: 90, equipment: "Barbell", coachingCue: "Hinge at hips; push pelvis straight backward."),
                            ExerciseItem(name: "Leg Extension Drop-Set", targetMuscle: "Quadriceps", sets: 3, reps: "12-15", restSeconds: 60, equipment: "Leg Machine", coachingCue: "Full quad squeeze at lockout; avoid swinging."),
                            ExerciseItem(name: "Hanging Leg Raises", targetMuscle: "Core & Hip Flexors", sets: 3, reps: "12-15", restSeconds: 60, equipment: "Pull-Up Bar", coachingCue: "Curl pelvis upwards rather than swinging legs.")
                        ]
                    )
                ]
            )
            
        case .mesomorph:
            return WorkoutPlan(
                somatotype: .mesomorph,
                title: "Athletic Density & Strength-Hypertrophy",
                splitDescription: "Upper / Lower Power-Hypertrophy Split",
                frequencyPerWeek: 5,
                primaryObjective: "Combine heavy compound lifts with high-volume isolation to exploit rapid neuromuscular adaptation.",
                sessions: [
                    WorkoutSession(
                        dayNumber: 1,
                        title: "Upper Power: Compound Domination",
                        focusArea: "Upper Body Strength",
                        estimatedDurationMinutes: 55,
                        exercises: [
                            ExerciseItem(name: "Flat Barbell Bench Press", targetMuscle: "Pectoralis Major", sets: 4, reps: "5-6", restSeconds: 120, equipment: "Barbell", coachingCue: "Retract scapulae; explosive upward drive."),
                            ExerciseItem(name: "Weighted Pull-Ups / Lat Pulldown", targetMuscle: "Lats & Biceps", sets: 4, reps: "6-8", restSeconds: 90, equipment: "Pull-Up Bar", coachingCue: "Full range of motion; chest touches bar at top."),
                            ExerciseItem(name: "Overhead Military Press", targetMuscle: "Shoulders & Core", sets: 3, reps: "6-8", restSeconds: 90, equipment: "Barbell", coachingCue: "Tuck chin slightly until bar clears head."),
                            ExerciseItem(name: "Barbell Bent-Over Row", targetMuscle: "Lats & Trapezius", sets: 4, reps: "8", restSeconds: 90, equipment: "Barbell", coachingCue: "Torso parallel to floor; pull to belly button.")
                        ]
                    ),
                    WorkoutSession(
                        dayNumber: 2,
                        title: "Lower Power: Posterior Drive",
                        focusArea: "Lower Body Strength",
                        estimatedDurationMinutes: 55,
                        exercises: [
                            ExerciseItem(name: "Conventional Deadlift", targetMuscle: "Erector Spinae & Hamstrings", sets: 4, reps: "5", restSeconds: 150, equipment: "Barbell", coachingCue: "Pull slack out of bar; engage lats before lifting."),
                            ExerciseItem(name: "Front Squats", targetMuscle: "Quadriceps & Upper Back", sets: 3, reps: "6-8", restSeconds: 90, equipment: "Barbell", coachingCue: "Keep elbows high; upright vertical torso."),
                            ExerciseItem(name: "Bulgarian Split Squats", targetMuscle: "Glutes & Quads", sets: 3, reps: "8-10/leg", restSeconds: 75, equipment: "Dumbbells & Bench", coachingCue: "Drive through front heel; maintain hip alignment."),
                            ExerciseItem(name: "Standing Calf Raises", targetMuscle: "Gastrocnemius", sets: 4, reps: "12-15", restSeconds: 60, equipment: "Machine", coachingCue: "2-second pause at bottom stretch position.")
                        ]
                    ),
                    WorkoutSession(
                        dayNumber: 3,
                        title: "Upper Hypertrophy: Metabolic Pump",
                        focusArea: "Upper Body Volume",
                        estimatedDurationMinutes: 50,
                        exercises: [
                            ExerciseItem(name: "Incline Dumbbell Press", targetMuscle: "Upper Chest", sets: 3, reps: "10-12", restSeconds: 75, equipment: "Dumbbells", coachingCue: "Deep stretch at bottom; squeeze without clanking weights."),
                            ExerciseItem(name: "Single-Arm Dumbbell Rows", targetMuscle: "Lats", sets: 3, reps: "10-12/arm", restSeconds: 60, equipment: "Dumbbell & Bench", coachingCue: "Row dumbbell back towards hip crease."),
                            ExerciseItem(name: "Cable Lateral Raises", targetMuscle: "Medial Deltoid", sets: 4, reps: "15", restSeconds: 45, equipment: "Cable Machine", coachingCue: "Constant tension at bottom range."),
                            ExerciseItem(name: "EZ-Bar Preacher Curls Super-set with Skullcrushers", targetMuscle: "Arms", sets: 3, reps: "12", restSeconds: 75, equipment: "EZ-Bar", coachingCue: "No rest between curl and skullcrusher transition.")
                        ]
                    )
                ]
            )
            
        case .endomorph:
            return WorkoutPlan(
                somatotype: .endomorph,
                title: "Metabolic conditioning & Lean Recomposition",
                splitDescription: "Full-Body Circuit & High-Density Hypertrophy",
                frequencyPerWeek: 4,
                primaryObjective: "Elevate post-exercise oxygen consumption (EPOC), stimulate insulin sensitivity, and burn fat while sparing lean mass.",
                sessions: [
                    WorkoutSession(
                        dayNumber: 1,
                        title: "Metabolic Circuit A: Full Body Resistance",
                        focusArea: "Full Body Glycogen Depletion",
                        estimatedDurationMinutes: 45,
                        exercises: [
                            ExerciseItem(name: "Goblet Squat to Overhead Press (Thruster)", targetMuscle: "Full Body", sets: 4, reps: "12-15", restSeconds: 45, equipment: "Kettlebell or Dumbbell", coachingCue: "Seamless power transfer from squat into press."),
                            ExerciseItem(name: "Kettlebell Swings", targetMuscle: "Glutes & Hamstrings", sets: 4, reps: "20", restSeconds: 45, equipment: "Kettlebell", coachingCue: "Snappy hip snap; do not squat the swing."),
                            ExerciseItem(name: "Push-Up to Renegade Row", targetMuscle: "Chest, Back & Core", sets: 3, reps: "10/side", restSeconds: 60, equipment: "Hex Dumbbells", coachingCue: "Widen stance to prevent hip rotation."),
                            ExerciseItem(name: "Farmer's Walk", targetMuscle: "Grip, Traps & Core", sets: 4, reps: "45 seconds", restSeconds: 60, equipment: "Heavy Dumbbells", coachingCue: "Tall posture, shoulders down and back.")
                        ]
                    ),
                    WorkoutSession(
                        dayNumber: 2,
                        title: "Hypertrophy Density: Upper Torso",
                        focusArea: "Shoulders, Back & Core",
                        estimatedDurationMinutes: 45,
                        exercises: [
                            ExerciseItem(name: "Incline Push-Ups / Bench Press", targetMuscle: "Chest", sets: 4, reps: "12", restSeconds: 60, equipment: "Barbell or Bench", coachingCue: "Keep elbows at 45 degrees to protect shoulders."),
                            ExerciseItem(name: "Seated Cable Rows", targetMuscle: "Mid Back", sets: 4, reps: "12", restSeconds: 60, equipment: "Cable Stack", coachingCue: "Hold peak contraction for 1 second."),
                            ExerciseItem(name: "Dumbbell Arnold Press", targetMuscle: "Deltoids", sets: 3, reps: "12", restSeconds: 60, equipment: "Dumbbells", coachingCue: "Smooth rotational sweep during press."),
                            ExerciseItem(name: "Mountain Climbers with Tempo", targetMuscle: "Core Conditioning", sets: 3, reps: "40 sec", restSeconds: 45, equipment: "Bodyweight", coachingCue: "Drive knees rhythmically without piking hips.")
                        ]
                    ),
                    WorkoutSession(
                        dayNumber: 3,
                        title: "Lower Body Conditioning & HIIT Finisher",
                        focusArea: "Legs & Cardiovascular Endurance",
                        estimatedDurationMinutes: 45,
                        exercises: [
                            ExerciseItem(name: "Walking Lunges with Dumbbells", targetMuscle: "Glutes & Quads", sets: 4, reps: "12 steps/leg", restSeconds: 60, equipment: "Dumbbells", coachingCue: "Maintain 90-degree bend in front and back knees."),
                            ExerciseItem(name: "Leg Press Fast Eccentric / Power Concentric", targetMuscle: "Quadriceps", sets: 3, reps: "15", restSeconds: 60, equipment: "Leg Press", coachingCue: "Do not lock knees out at top."),
                            ExerciseItem(name: "Hamstring Swiss-Ball Curls", targetMuscle: "Hamstrings", sets: 3, reps: "15", restSeconds: 45, equipment: "Swiss Ball", coachingCue: "Lift hips high while dragging heels inwards."),
                            ExerciseItem(name: "Assault Bike or Sprint Intervals", targetMuscle: "Cardiovascular System", sets: 6, reps: "30s sprint / 30s rest", restSeconds: 30, equipment: "Bike or Treadmill", coachingCue: "All-out maximum wattage exertion.")
                        ]
                    )
                ]
            )
        }
    }
}
