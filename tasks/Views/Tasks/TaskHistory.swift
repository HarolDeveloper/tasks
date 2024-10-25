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
    var completedTasks: [RoommateTaskAssignment]
    
    var body: some View {
        ScrollView {
            if (completedTasks.isEmpty){
                Text("No hay ninguna tarea completada aún")
            }
            else {
                VStack {
                    ForEach(completedTasks, id: \.self) { task in
                        HistoryTaskCard(taskTitle: task.task!.title, taskDateTime: dateToString())
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


