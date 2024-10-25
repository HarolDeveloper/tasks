//
//  AssigmentRow.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 25/10/24.
//

import SwiftUI

struct AssignmentRow: View {
    let assignment: RoommateTaskAssignment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Task Title and Status
            HStack {
                if let task = assignment.task {
                    Text(task.title)
                        .font(.headline)
                }
                
                Spacer()
                
                StatusBadge(status: assignment.status)
            }
            
            // Time and Description
            if let start = assignment.scheduledStart,
               let end = assignment.scheduledEnd {
                TimeInfoView(start: start, end: end)
            }
            
            if let task = assignment.task,
               let description = task.taskDescription {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            // Footer Info
            HStack {
                // Assigned User
                Label(assignment.assignedUserDisplayName,
                      systemImage: "person.fill")
                    .foregroundColor(.blue)
                
                Spacer()
                
                // Points if any
                if let points = assignment.pointsEarned {
                    Label("\(points) pts",
                          systemImage: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
            .font(.caption)
        }
    }
}

struct TimeInfoView: View {
    let start: Date
    let end: Date
    
    var body: some View {
        HStack {
            Image(systemName: "clock.fill")
                .foregroundColor(.blue)
            
            Text(formatTimeRange(start: start, end: end))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private func formatTimeRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
}

struct StatusBadge: View {
    let status: String
    
    private var statusInfo: (color: Color, icon: String) {
        switch status.lowercased() {
        case "completed":
            return (.green, "checkmark.circle.fill")
        case "in_progress":
            return (.blue, "clock.fill")
        case "pending":
            return (.orange, "hourglass")
        case "failed":
            return (.red, "xmark.circle.fill")
        default:
            return (.gray, "circle.fill")
        }
    }
    
    var body: some View {
        Label(status.capitalized, systemImage: statusInfo.icon)
            .font(.caption)
            .foregroundColor(statusInfo.color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusInfo.color.opacity(0.1))
            .cornerRadius(8)
    }
}
