//
//  WorkoutPlanView.swift
//  FitVision
//
//  Created for IT22177100 - Advanced Mobile Application Development
//  Architectural Note: Workout Blueprint Component
//  Displays structured exercises, sets, reps, coaching cues,
//  and interactive completion tracking.
//

import SwiftUI

struct WorkoutPlanView: View {
    @Binding var workoutPlan: WorkoutPlan
    @State private var selectedDayIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 16) {
            // MARK: - Plan Summary Banner
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label(workoutPlan.splitDescription, systemImage: "figure.run")
                        .font(.caption.weight(.bold))
                        .foregroundColor(workoutPlan.somatotype.accentColor)
                    
                    Spacer()
                    
                    Text("\(workoutPlan.frequencyPerWeek) Days / Week")
                        .font(.caption.bold())
                        .foregroundColor(.primary)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4)
                        .background(Color.fitSurface)
                        .clipShape(Capsule())
                        .overlay(Capsule().strokeBorder(Color.fitBorder, lineWidth: 1))
                }
                
                Text(workoutPlan.title)
                    .font(.title3.bold())
                    .foregroundColor(.primary)
                
                Text(workoutPlan.primaryObjective)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .glassmorphicCard(cornerRadius: 18)
            .padding(.horizontal, 16)
            
            // MARK: - Day Selector Tabs
            if !workoutPlan.sessions.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(workoutPlan.sessions.enumerated()), id: \.element.id) { index, session in
                            Button(action: {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                    selectedDayIndex = index
                                }
                                HapticManager.shared.selection()
                            }) {
                                HStack(spacing: 6) {
                                    Text("Day \(session.dayNumber)")
                                        .font(.caption.bold())
                                    
                                    if session.exercises.allSatisfy({ $0.isCompleted }) && !session.exercises.isEmpty {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 11))
                                            .foregroundColor(.fitEmerald)
                                    }
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(selectedDayIndex == index ? workoutPlan.somatotype.accentColor.opacity(0.18) : Color.fitSurface)
                                .foregroundColor(selectedDayIndex == index ? workoutPlan.somatotype.accentColor : .primary)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule().strokeBorder(selectedDayIndex == index ? workoutPlan.somatotype.accentColor : Color.fitBorder, lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                // MARK: - Selected Session Focus
                let activeSession = workoutPlan.sessions[selectedDayIndex]
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(activeSession.title)
                            .font(.headline.bold())
                            .foregroundColor(.primary)
                        Spacer()
                        Label("\(activeSession.estimatedDurationMinutes) mins", systemImage: "clock")
                            .font(.caption.weight(.medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Text("Focus: \(activeSession.focusArea)")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(workoutPlan.somatotype.accentColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 4)
                
                // MARK: - Exercises List
                VStack(spacing: 12) {
                    ForEach(activeSession.exercises.indices, id: \.self) { exIndex in
                        let exercise = activeSession.exercises[exIndex]
                        
                        ExerciseRowCard(
                            exercise: exercise,
                            accentColor: workoutPlan.somatotype.accentColor
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                workoutPlan.sessions[selectedDayIndex].exercises[exIndex].isCompleted.toggle()
                            }
                            HapticManager.shared.selection()
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - Exercise Row Card Component
private struct ExerciseRowCard: View {
    let exercise: ExerciseItem
    let accentColor: Color
    let toggleAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.name)
                        .font(.subheadline.bold())
                        .foregroundColor(exercise.isCompleted ? .secondary : .primary)
                        .strikethrough(exercise.isCompleted)
                    
                    Text(exercise.targetMuscle)
                        .font(.caption2.weight(.bold))
                        .foregroundColor(accentColor)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(accentColor.opacity(0.12))
                        .clipShape(Capsule())
                }
                
                Spacer()
                
                // Completion Toggle
                Button(action: toggleAction) {
                    Image(systemName: exercise.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(exercise.isCompleted ? Color.fitEmerald : Color.secondary.opacity(0.6))
                }
                .buttonStyle(.plain)
            }
            
            // Refined Stats Strip: Sets, Reps, Rest, Equipment
            HStack(spacing: 6) {
                Text("\(exercise.sets) sets")
                Text("•")
                Text("\(exercise.reps) reps")
                Text("•")
                Text("\(exercise.restSeconds)s rest")
                Text("•")
                Text(exercise.equipment)
            }
            .font(.caption2.weight(.medium))
            .foregroundColor(.secondary)
            
            // Coaching Cue Callout
            HStack(alignment: .top, spacing: 6) {
                Image(systemName: "lightbulb.fill")
                    .font(.caption2)
                    .foregroundColor(Color.fitGold)
                    .padding(.top, 1)
                
                Text(exercise.coachingCue)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.fitSurface)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(Color.fitBorder, lineWidth: 1)
            )
        }
        .glassmorphicCard(cornerRadius: 16)
        .opacity(exercise.isCompleted ? 0.65 : 1.0)
    }
}
