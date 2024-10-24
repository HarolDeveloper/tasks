//
//  TaskHistory.swift
//  tasks
//
//  Created by Valente Alvarez on 23/10/24.
//

import SwiftUI

// Temporary helper function, should be moved to the ViewModel
func dateToString(date: Date = Date.now) -> String {
    let formatter1 = DateFormatter()
    formatter1.dateStyle = .full
    return formatter1.string(from: date)
}

struct TaskHistory: View {    
    var completedTasks: [Task]
    
    var body: some View {
        ScrollView {
            if (completedTasks.isEmpty){
                Text("No hay ninguna tarea completada aún")
            }
            else {
                VStack {
                    ForEach(completedTasks, id: \.self) { task in
                        HistoryTaskCard(taskTitle: task.title, taskDateTime: dateToString())
                            .listRowSeparator(.hidden)
                    }
                }
                .padding()
                .background(Color.white)
    //            .cornerRadius(20)
    //            .shadow(radius: 50)
            }
        }
    }
}

// Testing values for preview
var testTasks: [Task] = [
    Task(title: "Task 1", priority: 1),
    Task(title: "Another task 2", priority: 1),
    Task(title: "Something to do", priority: 1),
    Task(title: "Whatever else", priority: 1),
]

#Preview {
    TaskHistory(completedTasks: testTasks)
}
