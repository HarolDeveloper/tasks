import SwiftUI
import SwiftData

@main
struct TasksApp: App {
    let container: ModelContainer
    
    init() {
        do {
            let schema = Schema([
                User.self,
                Task.self,
                HousingGroup.self,
                // Añade aquí otros modelos que necesites
            ])
            
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )
            
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Error initializing ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
