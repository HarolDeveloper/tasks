//
//  MainTabView.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 24/10/24.
//

import SwiftUI
import SwiftData

// MARK: - MainTabView
struct MainTabView: View {
    @State private var userViewModel: UserViewModel
    let modelContext: ModelContext
    @State private var selectedTab = 0
    
    init(userViewModel: UserViewModel, modelContext: ModelContext) {
        _userViewModel = State(initialValue: userViewModel)
        self.modelContext = modelContext
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                Dashboard(
                    userViewModel: userViewModel,
                    modelContext: modelContext
                )
            }
            .tabItem {
                Label("Dashboard", systemImage: "house.fill")
            }
            .tag(0)
            
            NavigationView {
                Dashboard(
                    userViewModel: userViewModel,
                    modelContext: modelContext
                )
            }
            .tabItem {
                Label("Perfil", systemImage: "person.fill")
            }
            .tag(1)
        }
    }
}

