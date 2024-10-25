// ContentView.swift
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var userViewModel: UserViewModel
    
    init(userViewModel: UserViewModel) {
        _userViewModel = StateObject(wrappedValue: userViewModel)
    }
    
    var body: some View {
        if userViewModel.isLoading {
            LoadingView()
        } else if let error = userViewModel.error {
            ErrorView(error: error) {
                userViewModel.retryLoading()
            }
        } else {
            MainTabView(userViewModel: userViewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let container = try! ModelContainer(
            for: Schema([
                User.self,
                TaskItem.self,  // Nuevo modelo de tarea
                TaskCategory.self,  // Nuevo modelo de categoría
                HousingGroup.self,
                UserProfile.self,
                RoommateUserStats.self,
                TaskType.self,
                RoommateTaskAssignment.self,
                HouseholdMember.self,
                UserCalendar.self,
                CalendarEvent.self,
                UserAvailabilitySlot.self,
                PointHistory.self
            ]),
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        // Agregar datos de ejemplo para el preview
        let context = container.mainContext
        
        // Crear una categoría de ejemplo
        let category = TaskCategory(
            name: "Limpieza",
            estimatedDuration: 60,
            points: 10,
            icon: "spray.sparkle.fill"
        )
        context.insert(category)
        
        // Crear una tarea de ejemplo
        let task = TaskItem(
            title: "Limpiar cocina",
            taskDescription: "Limpieza profunda semanal",
            status: "pending",
            priority: 1,
            category: category
        )
        context.insert(task)
        
        let userState = UserState()
        let viewModel = UserViewModel(
            userState: userState,
            modelContext: container.mainContext
        )
        
        return ContentView(userViewModel: viewModel)
            .modelContainer(container)
    }
}
