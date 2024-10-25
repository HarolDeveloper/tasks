//
//  TodayTaskCard.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 23/10/24.
//

import SwiftUI

// Actualiza TodayTasksCard para usar AssignmentRow
struct TodayTasksCard: View {
    let assignments: [RoommateTaskAssignment]
    let currentUserId: UUID?
    
    private var userAssignments: [RoommateTaskAssignment] {
        guard let userId = currentUserId else { return [] }
        return assignments.filter { $0.assignedUserProfile?.id == userId }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if userAssignments.isEmpty {
                EmptyTasksView()
            } else {
                ForEach(userAssignments) { assignment in
                    AssignmentRow(assignment: assignment)
                    
                    if assignment.id != userAssignments.last?.id {
                        Divider()
                            .padding(.vertical, 8)
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
}


struct TasksContent: View {
    let tasksViewModel: TasksViewModel
    let userViewModel: UserViewModel
    let completedTasks: [RoommateTaskAssignment]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Label("Tareas de Hoy", systemImage: "calendar")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                if !completedTasks.isEmpty {
                    NavigationLink(destination: TaskHistory(completedTasks: completedTasks)) {
                        Label("Historial", systemImage: "clock.arrow.circlepath")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal, 8)
            
            // Tasks Content
            if tasksViewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 200)
            } else {
                TodayTasksCard(
                    assignments: tasksViewModel.assignments,
                    currentUserId: userViewModel.currentUser?.id
                )
            }
        }
    }
}
