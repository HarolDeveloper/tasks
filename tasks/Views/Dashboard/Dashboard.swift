//
//  Dashboard.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 23/10/24.
//

import SwiftUI
import SwiftData

struct Dashboard: View {
    @ObservedObject var userViewModel: UserViewModel
    @StateObject private var tasksViewModel: TasksViewModel
    
    init(userViewModel: UserViewModel, modelContext: ModelContext) {
        self.userViewModel = userViewModel
        _tasksViewModel = StateObject(wrappedValue: TasksViewModel(modelContext: modelContext))
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
                        .padding(.bottom, 8)
                }
                
                // Stats Grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
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
                
                // Today's Tasks Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Tareas de Hoy")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        if !completedTasks.isEmpty {
                            NavigationLink(destination: TaskHistory(completedTasks: completedTasks)) {
                                Label("Historial", systemImage: "clock.arrow.circlepath")
                                    .font(.subheadline)
                            }
                        }
                    }
                    
                    // Usar TasksContent para mostrar las tareas
                    TasksContent(
                        isLoading: tasksViewModel.isLoading,
                        todayTasks: tasksViewModel.todayTasks
                    )
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle("Dashboard")
        .refreshable {
            await tasksViewModel.refresh()
        }
    }
}

// MARK: - Supporting Views
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}
