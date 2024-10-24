import Foundation
import SwiftData
import Combine

@Observable
class TasksViewModel {
    private let modelContext: ModelContext
    private(set) var tasks: [Task] = []
    private(set) var assignments: [RoommateTaskAssignment] = []
    private(set) var todayTasks: [Task] = []
    private(set) var isLoading = false
    
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
    
    private func loadInitialData() {
        loadTasks()
        loadAssignments()
        updateStats()
    }
    
    func refresh() async {
        isLoading = true
        // Limpiar los arrays antes de recargar
        tasks = []
        assignments = []
        todayTasks = []
        
        loadTasks()
        loadAssignments()
        updateStats()
        isLoading = false
    }
    
    private func loadTasks() {
        do {
            // Primero limpiar los datos existentes
            try cleanExistingData()
            
            // Luego cargar el JSON
            guard let url = Bundle.main.url(forResource: "tasks", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                print("Could not find tasks.json in bundle")
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
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
            
            let response = try decoder.decode(TasksResponse.self, from: data)
            
            // Procesar y guardar los datos en lotes
            for taskDTO in response.tasks {
                let taskType = TaskType(
                    name: taskDTO.taskType.name,
                    estimatedDuration: taskDTO.taskType.estimatedDuration,
                    points: taskDTO.taskType.points
                )
                taskType.id = taskDTO.taskType.id
                modelContext.insert(taskType)
                
                let task = Task(title: taskDTO.title, priority: taskDTO.priority)
                task.id = taskDTO.id
                task.taskDescription = taskDTO.description
                task.status = taskDTO.status
                task.createdAt = taskDTO.createdAt
                task.dueDate = taskDTO.dueDate
                task.taskType = taskType
                
                modelContext.insert(task)
                tasks.append(task)
                
                // Guardar cada cierto número de inserciones para evitar sobrecarga
                if tasks.count % 10 == 0 {
                    try modelContext.save()
                }
            }
            
            // Guardar cambios finales
            try modelContext.save()
            
        } catch {
            print("Error en loadTasks: \(error)")
        }
    }
    
    private func cleanExistingData() throws {
        // Primero eliminar las asignaciones
        let assignmentDescriptor = FetchDescriptor<RoommateTaskAssignment>()
        if let existingAssignments = try? modelContext.fetch(assignmentDescriptor) {
            existingAssignments.forEach { modelContext.delete($0) }
        }
        
        // Luego eliminar las tareas
        let taskDescriptor = FetchDescriptor<Task>()
        if let existingTasks = try? modelContext.fetch(taskDescriptor) {
            existingTasks.forEach { modelContext.delete($0) }
        }
        
        // Finalmente eliminar los tipos de tarea
        let typeDescriptor = FetchDescriptor<TaskType>()
        if let existingTypes = try? modelContext.fetch(typeDescriptor) {
            existingTypes.forEach { modelContext.delete($0) }
        }
        
        try modelContext.save()
        
        // Limpiar los arrays locales
        tasks = []
        assignments = []
        todayTasks = []
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
                let assignments: [AssignmentDTO]
            }
            
            struct AssignmentDTO: Codable {
                let id: UUID
                let status: String
                let assignedAt: Date
                let scheduledStart: Date?
                let scheduledEnd: Date?
                let completedAt: Date?
                let taskId: String
            }
            
            let response = try decoder.decode(AssignmentsResponse.self, from: data)
            
            for assignmentDTO in response.assignments {
                if let task = tasks.first(where: { $0.id.uuidString == assignmentDTO.taskId }) {
                    let assignment = RoommateTaskAssignment(status: assignmentDTO.status)
                    assignment.id = assignmentDTO.id
                    assignment.assignedAt = assignmentDTO.assignedAt
                    assignment.scheduledStart = assignmentDTO.scheduledStart
                    assignment.scheduledEnd = assignmentDTO.scheduledEnd
                    assignment.completedAt = assignmentDTO.completedAt
                    assignment.task = task
                    
                    modelContext.insert(assignment)
                    assignments.append(assignment)
                }
            }
            
            try modelContext.save()
            
        } catch {
            print("Error loading assignments: \(error)")
        }
    }
    
    private func updateStats() {
        let calendar = Calendar.current
        let today = Date()
        
        todayTasks = tasks.filter { task in
            if let dueDate = task.dueDate {
                return calendar.isDate(dueDate, inSameDayAs: today)
            }
            return false
        }
    }
}
