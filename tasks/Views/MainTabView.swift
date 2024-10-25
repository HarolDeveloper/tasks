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
				AddTaskView(selectedTaskType: "") // <--- PLACEHOLDER!!
            }
            .tabItem {
                Label("Agregar Tarea", systemImage: "plus.circle.fill")
            }
            .tag(1) // Cambie esto pero no tengo idea de que es, creo que rompe las tareas mostradas en el dashboard!!
			
			NavigationStack {
				ProfileView(userViewModel: userViewModel)
			}
			.tabItem {
				Label("Perfil", systemImage: "person.fill")
			}
			.tag(2) // Esto tambien lo cambie, antes era 1, pero queria tener el boton de agregar en medio.
        }
    }
}
