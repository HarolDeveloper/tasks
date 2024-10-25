import Foundation
import SwiftData
import Combine

@Observable
class TasksViewModel: ObservableObject {
    private let modelContext: ModelContext
    private(set) var tasks: [Task] = []
    private(set) var assignments: [RoommateTaskAssignment] = []
    private(set) var todayTasks: [Task] = []
    private(set) var isLoading = false
    
    // Computed properties - no necesitan @Published
    var pendingTasks: Int {
        tasks.filter { $0.status == "pending" }.count
    }
    
    var completedTasks: Int {
        tasks.filter { $0.status == "completed" }.count
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadInitialData()
    }
    
    // MARK: - Data Loading
    private func loadInitialData() {
        isLoading = true
        loadTasks()
        loadAssignments()
        updateStats()
        isLoading = false
    }
    
    @MainActor
      func refresh() async {
          isLoading = true
          // Clear existing arrays before loading new data
          tasks = []
          assignments = []
          todayTasks = []
          loadTasks()
          loadAssignments()
          updateStats()
          isLoading = false
      }
    
    private func loadTasks() {
        guard let url = Bundle.main.url(forResource: "tasks", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Could not find tasks.json in bundle")
            return
        }
        
        do {
            // Debug print JSON
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Loading JSON: \(jsonString)")
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let response = try decoder.decode(TasksResponse.self, from: data)
            
            // Clean existing data
            try cleanExistingData()
            
            // Process tasks
            var processedTaskIds = Set<UUID>() // Para rastrear IDs ya procesados
                
                for taskDTO in response.tasks {
                    if !processedTaskIds.contains(taskDTO.id) {
                        // Create TaskType
                        let taskType = TaskType(
                            name: taskDTO.taskType.name,
                            estimatedDuration: taskDTO.taskType.estimatedDuration,
                            points: taskDTO.taskType.points
                        )
                        taskType.id = taskDTO.taskType.id
                        modelContext.insert(taskType)
                        
                        // Create Task
                        let task = Task(title: taskDTO.title, priority: taskDTO.priority)
                        task.id = taskDTO.id
                        task.taskDescription = taskDTO.description
                        task.status = taskDTO.status
                        task.createdAt = taskDTO.createdAt
                        task.dueDate = taskDTO.dueDate
                        task.taskType = taskType
                        
                        modelContext.insert(task)
                        tasks.append(task)
                        
                        processedTaskIds.insert(taskDTO.id)
                    }
                }
            
            try modelContext.save()
            
            // Debug print computed statistics
            print("=== Debug: Tareas Cargadas ===")
            print("Total tareas: \(tasks.count)")
            print("Pendientes: \(pendingTasks)")
            print("Completadas: \(completedTasks)")
            print("Tareas de hoy: \(todayTasks.count)")
            
        } catch {
            print("Error loading tasks: \(error)")
            handleDecodingError(error)
        }
    }
    
    func getAssignment(for task: Task) -> RoommateTaskAssignment? {
            assignments.first { $0.task?.id == task.id }
        }
        
        // Método para obtener el nombre del usuario asignado a una tarea
        func getAssignedUserName(for task: Task) -> String {
            getAssignment(for: task)?.assignedUserDisplayName ?? "Sin asignar"
        }
        
        // Método para obtener todas las tareas de un usuario
        func getTasks(for userId: UUID) -> [Task] {
            assignments
                .filter { $0.assignedUserId == userId }
                .compactMap { $0.task }
        }
    
    private func handleDecodingError(_ error: Error) {
        if let decodingError = error as? DecodingError {
            switch decodingError {
            case .keyNotFound(let key, let context):
                print("Missing key: \(key.stringValue), path: \(context.codingPath)")
            case .valueNotFound(let type, let context):
                print("Missing value of type \(type), path: \(context.codingPath)")
            case .typeMismatch(let type, let context):
                print("Type mismatch: expected \(type), path: \(context.codingPath)")
            case .dataCorrupted(let context):
                print("Data corrupted: \(context)")
            @unknown default:
                print("Unknown decoding error")
            }
        }
    }
    
    private func cleanExistingData() throws {
        let taskDescriptor = FetchDescriptor<Task>()
        if let existingTasks = try? modelContext.fetch(taskDescriptor) {
            existingTasks.forEach { modelContext.delete($0) }
        }
        
        let typeDescriptor = FetchDescriptor<TaskType>()
        if let existingTypes = try? modelContext.fetch(typeDescriptor) {
            existingTypes.forEach { modelContext.delete($0) }
        }
        
        try modelContext.save()
    }
    
    private func loadAssignments() {
        guard let url = Bundle.main.url(forResource: "task-assignments", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Could not find task-assignments.json in bundle")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let response = try decoder.decode(AssignmentsResponse.self, from: data)
            
            // Limpiar asignaciones existentes
            let descriptor = FetchDescriptor<RoommateTaskAssignment>()
            if let existingAssignments = try? modelContext.fetch(descriptor) {
                existingAssignments.forEach { modelContext.delete($0) }
            }
            
            // Vincular y guardar nuevas asignaciones
            for assignment in response.assignments {
                if let taskId = assignment.taskId,
                   let task = tasks.first(where: { $0.id.uuidString == taskId }) {
                    assignment.task = task
                }
                modelContext.insert(assignment)
            }
            assignments = response.assignments
            
            try modelContext.save()
            print("Asignaciones cargadas: \(assignments.count)")
            
        } catch {
            print("Error loading assignments: \(error)")
        }
    }
    
    private func updateStats() {
        let calendar = Calendar.current
        let today = Date()
        
        // Update today's tasks
        todayTasks = tasks.filter { task in
            if let dueDate = task.dueDate {
                return calendar.isDate(dueDate, inSameDayAs: today)
            }
            return false
        }
    }
}

// MARK: - Supporting Types
struct TasksResponse: Codable {
    let tasks: [TaskDTO]
}

struct TaskDTO: Codable {
    let id: UUID
    let title: String
    let description: String?
    let status: String
    let priority: Int
    let createdAt: Date
    let dueDate: Date?
    let taskType: TaskTypeDTO
}

struct TaskTypeDTO: Codable {
    let id: UUID
    let name: String
    let estimatedDuration: Int
    let points: Int
}

struct AssignmentsResponse: Codable {
    let assignments: [RoommateTaskAssignment]
}
