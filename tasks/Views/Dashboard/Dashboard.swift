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
    let completedTasks: [Task]
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
                        value: completedTasks.count,
                        color: .green
                    )
                }
                
                // Today's Tasks
                TodayTasksCard(tasks: todayTasks)
                
                // Task
                NavigationLink(destination: TaskHistory(completedTasks: completedTasks)) {
                    Text("Ver tareas completadas")
                }
                
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
        
        let task3 = Task(title: "Trapear la cocina", priority: 1)
        task3.taskDescription = "Limpiar bien las esquinas con cloralex"
        task3.dueDate = Calendar.current.date(byAdding: .hour, value: 8, to: Date())
        task3.status = "completed"
        
        let task4 = Task(title: "Sacar la basura", priority: 1)
        task4.taskDescription = "Asegurarse de sacarla entre 3pm y 7pm"
        task4.dueDate = Calendar.current.date(byAdding: .hour, value: 3, to: Date())
        
        let task5 = Task(title: "Traer garrafones", priority: 1)
        task5.taskDescription = "Revisar bien que los garrafones no esten rotos"
        task5.dueDate = Calendar.current.date(byAdding: .hour, value: 4, to: Date())
        task5.status = "completed"
        
        let task6 = Task(title: "Pagar la luz", priority: 3)
        task6.taskDescription = "Revisen la cuenta de CFE en el grupo de whatsapp"
        task6.dueDate = Calendar.current.date(byAdding: .hour, value:  1, to: Date())
        
        return [task1, task2, task3, task4, task5, task6]
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
            completedTasks: tasks.filter { $0.status == "completed" },
            todayTasks: tasks
        )
    }
    .modelContainer(container)
}
