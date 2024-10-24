import Foundation
import SwiftData
import Combine

@Observable
class TasksViewModel {
    private let modelContext: ModelContext
    private(set) var tasks: [Task] = []
    private(set) var assignments: [RoommateTaskAssignment] = []
    
    // Dashboard stats - now computed from tasks
    var pendingTasks: Int {
        tasks.filter { $0.status == "pending" }.count
    }
    
    var completedTasks: Int {
        tasks.filter { $0.status == "completed" }.count
    }
    
    private(set) var todayTasks: [Task] = []
    private(set) var isLoading = false
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadInitialData()
    }
    
    // MARK: - Data Loading
    private func loadInitialData() {
        loadTasks()
        loadAssignments()
        updateStats()
    }
    
    func refresh() async {
        isLoading = true
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
                
                // Simplified response structure without statistics
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
                
                // Decode response
                let response = try decoder.decode(TasksResponse.self, from: data)
                
                // Clean existing data
                try cleanExistingData()
                
                // Process tasks
                for taskDTO in response.tasks {
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
        }
    
    private func cleanExistingData() throws {
        // Limpiar tareas existentes
        let taskDescriptor = FetchDescriptor<Task>()
        if let existingTasks = try? modelContext.fetch(taskDescriptor) {
            existingTasks.forEach { modelContext.delete($0) }
        }
        
        // Limpiar tipos de tarea existentes
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
            
            struct AssignmentsResponse: Codable {
                let assignments: [RoommateTaskAssignment]
            }
            
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
