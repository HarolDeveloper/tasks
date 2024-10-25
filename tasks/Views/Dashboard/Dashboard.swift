//
//  Dashboard.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 23/10/24.
//

import SwiftUI
import SwiftData



struct Dashboard: View {
    @State private var tasksViewModel: TasksViewModel
    @State private var userViewModel: UserViewModel
    
    init(userViewModel: UserViewModel, modelContext: ModelContext) {
        _userViewModel = State(initialValue: userViewModel)
        _tasksViewModel = State(initialValue: TasksViewModel(modelContext: modelContext))
    }
    
    private var completedTasks: [RoommateTaskAssignment] {
        tasksViewModel.assignments.filter { $0.status == "completed" }
    }
    
    private var pendingTasks: [RoommateTaskAssignment] {
        tasksViewModel.assignments.filter { $0.status == "pending" }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // User Header
                if let profile = userViewModel.userProfile {
                    UserHeaderView(profile: profile)
                        .padding(.bottom, 8)
                }
                
                // Stats Grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    StatCard(
                        title: "Pendientes",
                        value: tasksViewModel.pendingAssignments,
                        color: .purple
                    )
                    
                    StatCard(
                        title: "Completadas",
                        value: tasksViewModel.completedAssignments,
                        color: .green
                    )
                }
                
                // Today's Tasks Section
                VStack(alignment: .leading, spacing: 12) {
                    TasksContent(
                        tasksViewModel: tasksViewModel,
                        userViewModel: userViewModel,
                        completedTasks: completedTasks
                    )
                }
                .padding(.top, 16)
            }
            .padding()
        }
        .navigationTitle("Dashboard")
        .refreshable {
            await tasksViewModel.refresh()
        }
    }
}
