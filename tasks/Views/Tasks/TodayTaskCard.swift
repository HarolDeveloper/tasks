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
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Label("Tareas de Hoy", systemImage: "calendar")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink(destination: AllTasksView()) {
                    Text("Ver todas")
                        .font(.subheadline)
                        .foregroundColor(.purple)
                }
            }
            
            if tasks.isEmpty {
                EmptyTasksView()
            } else {
                tasksList
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var tasksList: some View {
        VStack(spacing: 12) {
            ForEach(tasks) { task in
                TaskRow(task: task)
            }
        }
    }
}

#Preview {
    TodayTasksCard(tasks: [Task(title: "Limpiar cocina", priority: 1)])
}
