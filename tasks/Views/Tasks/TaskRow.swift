//
//  TaskRow.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 23/10/24.
//

import SwiftUI

struct TaskRow: View {
    let task: Task
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        HStack(spacing: 12) {
            // Task Status Indicator
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            
            // Task Title
            Text(task.title)
                .font(.system(.body, weight: .medium))
            
            Spacer()
            
            // Assignees
            HStack(spacing: -8) {
                ForEach(Array(task.assignments.prefix(3)), id: \.id) { assignment in
                    AssigneeAvatar(assignment: assignment)
                }
                
                if task.assignments.count > 3 {
                    Text("+\(task.assignments.count - 3)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                }
            }
            
            // Navigation Chevron
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
    
    private var statusColor: Color {
        switch task.status {
        case "pending": return .orange
        case "inProgress": return .blue
        case "completed": return .green
        default: return .gray
        }
    }
}

#Preview {
    let task = Task(title: "Limpiar cocina", priority: 1)
    return TaskRow(task: task)
}
