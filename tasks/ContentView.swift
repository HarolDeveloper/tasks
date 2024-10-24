
// ContentView.swift
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [Task]
    
    // Computed properties para las estadísticas
    private var pendingTasks: Int {
        tasks.filter { $0.status == "pending" }.count
    }
    
    private var completedTasks: [Task] {
        tasks.filter { $0.status == "completed" }
    }
    
    private var todayTasks: [Task] {
        let calendar = Calendar.current
        return tasks.filter { task in
            if let dueDate = task.dueDate {
                return calendar.isDateInToday(dueDate)
            }
            return false
        }
    }
    
    var body: some View {
        NavigationStack {
            Dashboard(
                pendingTasks: pendingTasks,
                completedTasks: completedTasks,
                todayTasks: todayTasks
            )
        }
    }
}
