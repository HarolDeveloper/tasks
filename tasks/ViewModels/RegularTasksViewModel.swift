import Foundation
import SwiftData

// Modelo principal de SwiftData
@Model
class TaskItem {
    @Attribute(.unique) var id: String
    var title: String
    var taskDescription: String?
    var status: String
    var priority: Int
    var createdAt: Date
    var dueDate: Date?
    @Relationship(deleteRule: .cascade) var category: TaskCategory?
    
    init(
        id: String = UUID().uuidString,
        title: String,
        taskDescription: String? = nil,
        status: String = "pending",
        priority: Int,
        createdAt: Date = Date(),
        dueDate: Date? = nil,
        category: TaskCategory? = nil
    ) {
        self.id = id
        self.title = title
        self.taskDescription = taskDescription
        self.status = status
        self.priority = priority
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.category = category
    }
}

@Model
class TaskCategory {
    @Attribute(.unique) var id: String
    var name: String
    var estimatedDuration: Int
    var points: Int
    var icon: String
    
    init(
        id: String = UUID().uuidString,
        name: String,
        estimatedDuration: Int,
        points: Int,
        icon: String
    ) {
        self.id = id
        self.name = name
        self.estimatedDuration = estimatedDuration
        self.points = points
        self.icon = icon
    }
}

// DTOs para decodificar el JSON
struct TaskItemDTO: Codable {
    let id: String
    let title: String
    let description: String
    let status: String
    let priority: Int
    let createdAt: String
    let dueDate: String
    let taskType: TaskCategoryDTO
    
    func toTaskItem(context: ModelContext) -> TaskItem {
        let category = taskType.toTaskCategory(context: context)
        return TaskItem(
            id: id,
            title: title,
            taskDescription: description,
            status: status,
            priority: priority,
            createdAt: createdAt.toDate() ?? Date(),
            dueDate: dueDate.toDate(),
            category: category
        )
    }
}

struct TaskCategoryDTO: Codable {
    let id: String
    let name: String
    let estimatedDuration: Int
    let points: Int
    let icon: String
    
    func toTaskCategory(context: ModelContext) -> TaskCategory {
        // Intentar encontrar una categoría existente
        let descriptor = FetchDescriptor<TaskCategory>(
            predicate: #Predicate<TaskCategory> { category in
                category.id == id
            }
        )
        
        if let existingCategory = try? context.fetch(descriptor).first {
            return existingCategory
        }
        
        // Si no existe, crear una nueva
        let category = TaskCategory(
            id: id,
            name: name,
            estimatedDuration: estimatedDuration,
            points: points,
            icon: icon
        )
        context.insert(category)
        return category
    }
}

struct TasksResponseDTO: Codable {
    let tasks: [TaskItemDTO]
}

// Extensión para convertir strings ISO8601 a Date
extension String {
    func toDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: self)
    }
}

@Observable
class TaskListViewModel {
    private var modelContext: ModelContext
    var taskItems: [TaskItem] = []
    var errorMessage: String?
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadInitialTaskItems()
    }
    
    func updateModelContext(_ newContext: ModelContext) {
        self.modelContext = newContext
        fetchTaskItems()
    }
    
    private func loadInitialTaskItems() {
        do {
            // Verificar si ya hay tareas en la base de datos
            let descriptor = FetchDescriptor<TaskItem>()
            let existingItems = try modelContext.fetch(descriptor)
            
            if existingItems.isEmpty {
                let jsonString = """
                {
                    "tasks": [
                        {
                            "id": "550e8400-e29b-41d4-a716-446655440000",
                            "title": "Limpiar cocina",
                            "description": "Limpieza profunda semanal",
                            "status": "pending",
                            "priority": 1,
                            "createdAt": "2024-10-24T10:00:00Z",
                            "dueDate": "2024-10-25T12:00:00Z",
                            "taskType": {
                                "id": "660e8400-e29b-41d4-a716-446655440001",
                                "name": "Limpieza",
                                "estimatedDuration": 60,
                                "points": 10,
                                "icon": "spray.sparkle.fill"
                            }
                        },
                        {
                            "id": "550e8400-e29b-41d4-a716-446655440001",
                            "title": "Comprar víveres",
                            "description": "Compras de la semana",
                            "status": "pending",
                            "priority": 2,
                            "createdAt": "2024-10-24T09:00:00Z",
                            "dueDate": "2024-10-25T15:00:00Z",
                            "taskType": {
                                "id": "660e8400-e29b-41d4-a716-446655440002",
                                "name": "Compras",
                                "estimatedDuration": 120,
                                "points": 15,
                                "icon": "cart.fill"
                            }
                        },
                        {
                            "id": "550e8400-e29b-41d4-a716-446655440002",
                            "title": "Lavar ropa",
                            "description": "Lavar y doblar ropa",
                            "status": "completed",
                            "priority": 1,
                            "createdAt": "2024-10-24T08:00:00Z",
                            "dueDate": "2024-10-25T18:00:00Z",
                            "taskType": {
                                "id": "660e8400-e29b-41d4-a716-446655440003",
                                "name": "Lavandería",
                                "estimatedDuration": 90,
                                "points": 12,
                                "icon": "washer.fill"
                            }
                        },
                        {
                            "id": "550e8400-e29b-41d4-a716-446655440003",
                            "title": "Barrer el patio",
                            "description": "Limpieza del patio trasero",
                            "status": "pending",
                            "priority": 3,
                            "createdAt": "2024-10-24T11:00:00Z",
                            "dueDate": "2024-10-25T16:00:00Z",
                            "taskType": {
                                "id": "660e8400-e29b-41d4-a716-446655440001",
                                "name": "Limpieza",
                                "estimatedDuration": 45,
                                "points": 8,
                                "icon": "leaf.fill"
                            }
                        }
                    ]
                }
                """
                
                let jsonData = jsonString.data(using: .utf8)!
                let decoder = JSONDecoder()
                let tasksResponse = try decoder.decode(TasksResponseDTO.self, from: jsonData)
                
                // Convertir DTO a modelos SwiftData
                for taskDTO in tasksResponse.tasks {
                    let taskItem = taskDTO.toTaskItem(context: modelContext)
                    modelContext.insert(taskItem)
                }
                
                try modelContext.save()
            }
            
            fetchTaskItems()
            
        } catch {
            errorMessage = "Error loading initial tasks: \(error.localizedDescription)"
        }
    }
    
    func fetchTaskItems() {
        do {
            let descriptor = FetchDescriptor<TaskItem>(sortBy: [SortDescriptor(\.priority)])
            taskItems = try modelContext.fetch(descriptor)
        } catch {
            errorMessage = "Error fetching tasks: \(error.localizedDescription)"
        }
    }
    
    func addTaskItem(
        title: String,
        description: String? = nil,
        priority: Int,
        dueDate: Date? = nil,
        category: TaskCategory? = nil
    ) {
        let taskItem = TaskItem(
            title: title,
            taskDescription: description,
            priority: priority,
            dueDate: dueDate,
            category: category
        )
        
        modelContext.insert(taskItem)
        
        do {
            try modelContext.save()
            fetchTaskItems()
        } catch {
            errorMessage = "Error saving task: \(error.localizedDescription)"
        }
    }
    
    func updateTaskStatus(taskItem: TaskItem, newStatus: String) {
        taskItem.status = newStatus
        
        do {
            try modelContext.save()
            fetchTaskItems()
        } catch {
            errorMessage = "Error updating task: \(error.localizedDescription)"
        }
    }
    
    func deleteTaskItem(_ taskItem: TaskItem) {
        modelContext.delete(taskItem)
        
        do {
            try modelContext.save()
            fetchTaskItems()
        } catch {
            errorMessage = "Error deleting task: \(error.localizedDescription)"
        }
    }
    
    func getTaskItemsByStatus(_ status: String) -> [TaskItem] {
        return taskItems.filter { $0.status == status }
    }
}
