//
//  Dashboard.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 23/10/24.
//

import SwiftUI
import SwiftData


struct Dashboard: View {
    let pendingTasks: Int
    let completedTasks: Int
    let todayTasks: [Task]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Stats Cards
                HStack(spacing: 16) {
                    StatCard(
                        title: "Pendientes",
                        value: pendingTasks,
                        color: .purple
                    )
                    
                    StatCard(
                        title: "Completadas",
                        value: completedTasks,
                        color: .green
                    )
                }
                
                // Today's Tasks
                TodayTasksCard(tasks: todayTasks)
            }
            .padding()
        }
        .navigationTitle("Dashboard")
    }
}

// Datos de ejemplo para el Preview
extension Dashboard {
    static var previewTasks: [Task] {
        let task1 = Task(title: "Limpiar cocina", priority: 1)
        task1.taskDescription = "Limpieza profunda semanal"
        task1.dueDate = Calendar.current.date(byAdding: .hour, value: 2, to: Date())
        
        let task2 = Task(title: "Comprar víveres", priority: 2)
        task2.taskDescription = "Compras de la semana"
        task2.dueDate = Calendar.current.date(byAdding: .hour, value: 5, to: Date())
        
        let task3 = Task(title: "Lavar ropa", priority: 1)
        task3.taskDescription = "Lavar y doblar ropa"
        task3.dueDate = Calendar.current.date(byAdding: .hour, value: 8, to: Date())
        
        return [task1, task2, task3]
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let schema = Schema([
        Task.self,
        TaskType.self,
        HousingGroup.self,
        RoommateTaskAssignment.self
    ])
    
    let container = try! ModelContainer(
        for: schema,
        configurations: config
    )
    
    // Insertar datos de ejemplo en el contenedor
    let tasks = Dashboard.previewTasks
    tasks.forEach { container.mainContext.insert($0) }
    
    return NavigationView {
        Dashboard(
            pendingTasks: 5,
            completedTasks: 3,
            todayTasks: tasks
        )
    }
    .modelContainer(container)
}
