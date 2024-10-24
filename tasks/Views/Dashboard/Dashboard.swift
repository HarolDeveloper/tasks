//
//  Dashboard.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 23/10/24.
//

import SwiftUI
import SwiftData

struct Dashboard: View {

    @State private var userViewModel: UserViewModel
    @State private var tasksViewModel: TasksViewModel
    
    init(userViewModel: UserViewModel, modelContext: ModelContext) {
        _userViewModel = State(initialValue: userViewModel)
        _tasksViewModel = State(initialValue: TasksViewModel(modelContext: modelContext))
    }
    
    private var completedTasks: [Task] {
        tasksViewModel.tasks.filter { $0.status == "completed" }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // User Header
      
              if let profile = userViewModel.userProfile {
                  UserHeaderView(profile: profile)
                }
                
                // Stats Cards
                HStack(spacing: 16) {
                    StatCard(
                        title: "Pendientes",
                        value: tasksViewModel.pendingTasks,
                        color: .purple
                    )
                    
                    StatCard(
                        title: "Completadas",
                        value: tasksViewModel.completedTasks,
                        color: .green
                    )
                }
                
                // User Stats
              //  if let stats = userViewModel.userStats {
                //    UserStatsCard(stats: stats)
               // }
                
                // Today's Tasks

                if tasksViewModel.isLoading {
                    ProgressView()
                } else if !tasksViewModel.todayTasks.isEmpty {
                    TodayTasksCard(tasks: tasksViewModel.todayTasks)
                  NavigationLink(destination: TaskHistory(completedTasks: completedTasks)) {
                    Text("Ver tareas completadas")
                }
                } else {
                    Text("No hay tareas para hoy")  
                }
            }
            .padding()
        }
        .navigationTitle("Dashboard")
        .refreshable {
            await tasksViewModel.refresh()
        }
    }
}

