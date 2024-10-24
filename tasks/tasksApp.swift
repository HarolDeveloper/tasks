import SwiftUI
import SwiftData

@main
struct TasksApp: App {
    let container: ModelContainer
    @State private var userState: UserState
    
    init() {
        do {
            // Configurar el container
            container = try ModelContainer(
                for: User.self, Task.self, HousingGroup.self,
                UserProfile.self, RoommateUserStats.self,
                TaskType.self, RoommateTaskAssignment.self,
                HouseholdMember.self, UserCalendar.self,
                CalendarEvent.self, UserAvailabilitySlot.self,
                PointHistory.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: false)
            )
            
            // Inicializar el estado del usuario
            _userState = State(initialValue: UserState())
            
        } catch {
            fatalError("Error initializing ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                userViewModel: UserViewModel(userState: userState, modelContext: container.mainContext)
            )
            .modelContainer(container)
        }
    }
}

