import SwiftData
import Foundation


// MARK: - Task Models
@Model
class TaskType {
    var id: UUID
    var name: String
    var taskDescription: String?
    var estimatedDuration: Int
    var points: Int
    var frequency: String?
    
    @Relationship(deleteRule: .cascade) var tasks: [Task]
    
    init(name: String, estimatedDuration: Int, points: Int) {
        self.id = UUID()
        self.name = name
        self.estimatedDuration = estimatedDuration
        self.points = points
        self.tasks = []
        self.taskDescription = nil
        self.frequency = nil
    }
}
