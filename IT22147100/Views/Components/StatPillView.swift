//
//  StatPillView.swift
//  FitVision
//
//  Created for IT22147100 - Advanced Mobile Application Development
//  Architectural Note: Reusable Metric Pill Component
//  Displays key performance indicators with SF Symbols, title, and value.
//

import SwiftUI

struct StatPillView: View {
    let icon: String
    let value: String
    let label: String
    var accentColor: Color = Color.fitEmerald
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(accentColor)
                .frame(width: 28, height: 28)
                .background(accentColor.opacity(0.14))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 1) {
                Text(value)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.fitSurface)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(Color.fitBorder, lineWidth: 1)
                )
        }
    }
}
