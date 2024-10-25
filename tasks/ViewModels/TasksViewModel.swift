import Foundation
import SwiftData
import Combine

// DTOs para decodificación
struct TaskTypeDTO: Codable {
    let id: String
    let name: String
    let estimatedDuration: Int
    let points: Int
    let icon: String
}

struct TaskDTO: Codable {
    let id: String
    let title: String
    let description: String
    let priority: Int
    let taskType: TaskTypeDTO
    
}

struct AssignedUserProfileDTO: Codable {
    let id: UUID
    let username: String
    let firstName: String
    let lastName: String
    
    func toUserProfile() -> UserProfile {
        let profile = UserProfile(firstName: firstName, lastName: lastName)
        profile.id = id
        return profile
    }
}


@Observable
class TasksViewModel {
    private let modelContext: ModelContext
    private var hasLoadedInitialData = false
    var assignments: [RoommateTaskAssignment] = []
    var todayAssignments: [RoommateTaskAssignment] = []
    var isLoading = false
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadInitialDataIfNeeded()
    }
    
    private func loadInitialDataIfNeeded() {
        guard !hasLoadedInitialData else { return }
        isLoading = true
        loadData()
    }
    
    private func loadData() {
        loadAssignments()
        updateStats()
        isLoading = false
        hasLoadedInitialData = true
    }
    
    
    
    @MainActor
    func refresh() async {
        guard !isLoading else { return }
        
        isLoading = true
        assignments = []
        todayAssignments = []
        loadData()
    }
    
    private func loadAssignments() {
        guard let url = Bundle.main.url(forResource: "task-assignments", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Could not find task-assignments.json in bundle")
            return
        }
        
        do {
            try cleanExistingAssignments()
            
            let decoder = JSONDecoder()
            let loadedAssignments = try decoder.decode([String: [RoommateTaskAssignment]].self, from: data)
            
            if let assignments = loadedAssignments["assignments"] {
                for assignment in assignments {
                    modelContext.insert(assignment)
                    self.assignments.append(assignment)
                }
            }
            
            try modelContext.save()
            print("Successfully loaded \(assignments.count) assignments")
            
        } catch {
            print("Error loading assignments: \(error)")
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("Key not found: \(key) in \(context.codingPath)")
                case .valueNotFound(let type, let context):
                    print("Value of type \(type) not found at \(context.codingPath)")
                case .typeMismatch(let type, let context):
                    print("Type mismatch: expected \(type) at \(context.codingPath)")
                case .dataCorrupted(let context):
                    print("Data corrupted: \(context)")
                @unknown default:
                    print("Unknown decoding error")
                }
            }
        }
    }
    
    private func updateStats() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        todayAssignments = assignments.filter { assignment in
            guard let scheduledStart = assignment.scheduledStart else { return false }
            return calendar.isDate(scheduledStart, inSameDayAs: today)
        }
    }
    
    
    private func cleanExistingAssignments() throws {
        let descriptor = FetchDescriptor<RoommateTaskAssignment>()
        if let existingAssignments = try? modelContext.fetch(descriptor) {
            existingAssignments.forEach { modelContext.delete($0) }
        }
        try modelContext.save()
    }
    
    
    var pendingAssignments: Int {
        assignments.filter { $0.status == "pending" }.count
    }
    
    var completedAssignments: Int {
        assignments.filter { $0.status == "completed" }.count
    }
    
    
    
}


