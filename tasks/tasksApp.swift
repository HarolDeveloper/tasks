import SwiftUI
import SwiftData

@main
struct TasksApp: App {
    let container: ModelContainer
    let userState: UserState
    
    init() {
        do {
            // Crear el schema incluyendo todos los modelos
            let schema = Schema([
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
            ])
            
            // Configuración del contenedor
            container = try ModelContainer(
                for: schema,
                configurations: ModelConfiguration(isStoredInMemoryOnly: false)
            )
            userState = UserState()
        } catch {
            fatalError("Error initializing ModelContainer: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                userViewModel: UserViewModel(
                    userState: userState,
                    modelContext: container.mainContext
                )
            )
            .modelContainer(container)
        }
    }
}
