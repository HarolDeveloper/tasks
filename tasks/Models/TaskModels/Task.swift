import SwiftData
import Foundation


@Model
class Task {
    var id: UUID
    var title: String
    var taskDescription: String?
    var status: String
    var createdAt: Date
    var dueDate: Date?
    var priority: Int
    
    @Relationship var taskType: TaskType?
    @Relationship var group: HousingGroup?
    @Relationship(deleteRule: .cascade) var assignments: [RoommateTaskAssignment]
    
    init(title: String, priority: Int) {
        self.id = UUID()
        self.title = title
        self.priority = priority
        self.status = "pending"
        self.createdAt = Date()
        self.taskDescription = nil
        self.dueDate = nil
        self.assignments = []
    }
}
