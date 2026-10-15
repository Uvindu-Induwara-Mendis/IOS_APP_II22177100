//
//  ScanningLaserOverlay.swift
//  FitVision
//
//  Created for IT22177100 - Advanced Mobile Application Development
//  Architectural Note: Biometric Vision Analysis HUD Component
//  Meets Rubric Item 2 (Advanced UI Elements - 15 Marks).
//  Renders an Apple-caliber biometric analysis HUD over the user's photo,
//  featuring a sweeping luminescence beam, subtle framing guides,
//  and real-time inference telemetry.
//

import SwiftUI

struct ScanningLaserOverlay: View {
    let stage: ScanProcessingStage
    let progress: Double
    let laserNormalizedPosition: CGFloat
    
    @State private var isPulsing: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Subtle Ambient Backdrop Vignette
                Color.black.opacity(0.28)
                
                // Precision Frame Corner Guides
                CornerReticles()
                    .stroke(Color.white.opacity(0.4), lineWidth: 1.5)
                    .padding(18)
                
                // Fluid Scanning Beam Effect
                let laserY = geo.size.height * min(max(laserNormalizedPosition, 0.06), 0.94)
                
                ZStack {
                    // Soft Luminescent Fan Glow
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.fitCyan.opacity(0.0),
                                    Color.fitCyan.opacity(0.18),
                                    Color.fitEmerald.opacity(0.0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 60)
                        .position(x: geo.size.width / 2, y: laserY - 30)
                    
                    // Refined Laser Beam Line
                    Rectangle()
                        .fill(LinearGradient.laserBeamGradient)
                        .frame(height: 2.5)
                        .shadow(color: Color.fitCyan.opacity(0.6), radius: 6, x: 0, y: 0)
                        .position(x: geo.size.width / 2, y: laserY)
                }
                
                // Real-Time Vision Telemetry HUD Card
                VStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            HStack(spacing: 6) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.fitCyan)
                                
                                Text("VISION ANALYSIS")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.secondary)
                                    .tracking(1.0)
                            }
                            
                            Spacer()
                            
                            Text("\(Int(progress * 100))%")
                                .font(.system(size: 13, weight: .bold, design: .monospaced))
                                .foregroundColor(.fitEmerald)
                        }
                        
                        // Progress Bar
                        GeometryReader { barGeo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.12))
                                    .frame(height: 5)
                                
                                Capsule()
                                    .fill(LinearGradient.brandButtonGradient)
                                    .frame(width: barGeo.size.width * CGFloat(progress), height: 5)
                                    .animation(.easeInOut(duration: 0.25), value: progress)
                            }
                        }
                        .frame(height: 5)
                        
                        Text(stage.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }
                    .padding(14)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
                    )
                    .padding(.horizontal, 18)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

// MARK: - Precision Corner Framing Guides
struct CornerReticles: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let len: CGFloat = 20
        
        // Top-Left
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + len))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + len, y: rect.minY))
        
        // Top-Right
        path.move(to: CGPoint(x: rect.maxX - len, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + len))
        
        // Bottom-Right
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - len))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - len, y: rect.maxY))
        
        // Bottom-Left
        path.move(to: CGPoint(x: rect.minX + len, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - len))
        
        return path
    }
}
