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



// TasksContent actualizado
struct TasksContent: View {
    let isLoading: Bool
    let todayTasks: [Task]
    
    var body: some View {
        if isLoading {
            LoadingCardView(title: "Cargando tareas...")
        } else if !todayTasks.isEmpty {
            TodayTasksCard(tasks: todayTasks)
        } else {
            EmptyStateView(
                icon: "checkmark.circle",
                title: "¡Todo al día!",
                message: "No hay tareas pendientes para hoy"
            )
        }
    }
}
