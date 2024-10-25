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
                RegularTaskListView()
                    .environment(\.modelContext, modelContext)
            }
            .tabItem {
                Label("Agregar Tarea", systemImage: "plus.circle.fill")
            }
            .tag(1)
            
            NavigationStack {
                ProfileView(userViewModel: userViewModel)
            }
            .tabItem {
                Label("Perfil", systemImage: "person.fill")
            }
            .tag(2)
            
            NavigationStack {
                CalendarView().environment(\.modelContext, modelContext)
            }
            .tabItem {
                Label("Calendario", systemImage: "calendar")
            }
            .tag(3)
        }
        
    }
}
