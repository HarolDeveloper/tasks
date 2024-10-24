import SwiftUI
import SwiftData

@main
struct TasksApp: App {
    let container: ModelContainer
    let userState: UserState
    
    init() {
        do {
            container = try ModelContainer(
                for: User.self, Task.self, HousingGroup.self,
                UserProfile.self, RoommateUserStats.self,
                TaskType.self, RoommateTaskAssignment.self,
                HouseholdMember.self, UserCalendar.self,
                CalendarEvent.self, UserAvailabilitySlot.self,
                PointHistory.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: false)
            )
            
            userState = UserState()
            
        } catch {
            fatalError("Error initializing ModelContainer: \(error)")
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
