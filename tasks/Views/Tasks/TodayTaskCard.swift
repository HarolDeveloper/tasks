//
//  TodayTaskCard.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 23/10/24.
//

import SwiftUI

struct TodayTasksCard: View {
    let tasks: [Task]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(tasks) { task in
                TaskRow(task: task)
                
                if task.id != tasks.last?.id {
                    Divider()
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}



struct TasksContent: View {
    @ObservedObject var tasksViewModel: TasksViewModel
    let isLoading: Bool
    let todayTasks: [Task]
    
    var body: some View {
        if isLoading {
            ProgressView()
        } else if todayTasks.isEmpty {
           
        } else {
            VStack(spacing: 12) {
                ForEach(todayTasks) { task in
                    VStack(alignment: .leading) {
                        TodayTasksCard(tasks: todayTasks)
                        
                        if let assignment = tasksViewModel.getAssignment(for: task) {
                            Text("Asignada a: \(assignment.assignedUserDisplayName)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.leading)
                        }
                    }
                }
            }
        }
    }
}
