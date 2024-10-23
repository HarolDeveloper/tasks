//
//  TodayTasksCard_Previews.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 23/10/24.
//

import SwiftUI

struct TodayTasksCard_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrollView {
                TodayTasksCard(tasks: [
                    Task(title: "Broom kitchen", priority: 1),
                    Task(title: "Buy groceries for the week", priority: 1),
                    Task(title: "Clean clothes", priority: 1)
                ])
                .padding()
            }
        }
    }
}

