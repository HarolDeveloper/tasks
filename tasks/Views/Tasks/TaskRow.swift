//
//  TaskRow.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 23/10/24.
//

import SwiftUI


struct TaskRow: View {
    let task: RoommateTaskAssignment
    
    var body: some View {
        HStack(spacing: 12) {
            // Status indicator
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            Text(task.task!.title)
            // Task details
            VStack(alignment: .leading, spacing: 4) {
                Text(task.task!.title)
                    .font(.headline)
                    .foregroundColor(.primary) // Asegurarse de que el texto sea visible
                
                if let description = task.task?.taskDescription {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                // Task metadata
                HStack(spacing: 8) {
                    Label(priorityText, systemImage: "flag.fill")
                        .foregroundColor(priorityColor)
                    
                    if let dueDate = task.scheduledEnd {
                        Label(formatDate(dueDate), systemImage: "clock")
                            .foregroundColor(.secondary)
                    }
                    
                    if let taskType = task.task?.taskType {
                        Label(taskType.name, systemImage: "tag.fill")
                            .foregroundColor(.blue)
                    }
                }
                .font(.caption)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }

    
    private var statusColor: Color {
        switch task.status {
        case "pending": return .yellow
        case "completed": return .green
        case "in_progress": return .blue
        default: return .gray
        }
    }
    
    private var priorityText: String {
        switch task.task?.priority {
        case 1: return "Baja"
        case 2: return "Media"
        case 3: return "Alta"
        default: return "Normal"
        }
    }
    
    private var priorityColor: Color {
        switch task.task?.priority {
        case 1: return .green
        case 2: return .orange
        case 3: return .red
        default: return .blue
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
