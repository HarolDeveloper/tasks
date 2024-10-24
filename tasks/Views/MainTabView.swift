//
//  MainTabView.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 24/10/24.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @ObservedObject var userViewModel: UserViewModel
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                Dashboard(
                    userViewModel: userViewModel,
                    modelContext: modelContext
                )
            }
            .tabItem {
                Label("Dashboard", systemImage: "house.fill")
            }
            .tag(0)
            
            NavigationStack {
                ProfileView(userViewModel: userViewModel)
            }
            .tabItem {
                Label("Perfil", systemImage: "person.fill")
            }
            .tag(1)
        }
    }
}
