import SwiftData
import Foundation


@Model
class RoommateUserStats: Codable {
    var id: UUID
    var totalPoints: Int
    var tasksCompleted: Int
    var tasksFailed: Int
    var currentStreak: Int
    var lastUpdated: Date
    var averageCompletionTime: TimeInterval?
    var preferredTaskTypes: [String: Int]
    
    @Relationship var user: User?
    
    enum CodingKeys: String, CodingKey {
        case id, totalPoints, tasksCompleted, tasksFailed, currentStreak
        case lastUpdated, averageCompletionTime, preferredTaskTypes
    }
    
    init() {
        self.id = UUID()
        self.totalPoints = 0
        self.tasksCompleted = 0
        self.tasksFailed = 0
        self.currentStreak = 0
        self.lastUpdated = Date()
        self.preferredTaskTypes = [:]
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        totalPoints = try container.decode(Int.self, forKey: .totalPoints)
        tasksCompleted = try container.decode(Int.self, forKey: .tasksCompleted)
        tasksFailed = try container.decode(Int.self, forKey: .tasksFailed)
        currentStreak = try container.decode(Int.self, forKey: .currentStreak)
        lastUpdated = try container.decode(Date.self, forKey: .lastUpdated)
        averageCompletionTime = try container.decodeIfPresent(TimeInterval.self, forKey: .averageCompletionTime)
        preferredTaskTypes = try container.decode([String: Int].self, forKey: .preferredTaskTypes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(totalPoints, forKey: .totalPoints)
        try container.encode(tasksCompleted, forKey: .tasksCompleted)
        try container.encode(tasksFailed, forKey: .tasksFailed)
        try container.encode(currentStreak, forKey: .currentStreak)
        try container.encode(lastUpdated, forKey: .lastUpdated)
        try container.encodeIfPresent(averageCompletionTime, forKey: .averageCompletionTime)
        try container.encode(preferredTaskTypes, forKey: .preferredTaskTypes)
    }
    
    // Método existente para actualizar estadísticas
    func updateStats(with assignment: RoommateTaskAssignment) {
        if assignment.status == "completed" {
            self.tasksCompleted += 1
            self.currentStreak += 1
            
            if let points = assignment.pointsEarned {
                self.totalPoints += points
            }
            
            // Actualizar tipo de tarea preferido
            if let taskType = assignment.task?.taskType?.name {
                preferredTaskTypes[taskType, default: 0] += 1
            }
            
            // Actualizar tiempo promedio de completación
            if let start = assignment.scheduledStart,
               let end = assignment.completedAt {
                let completionTime = end.timeIntervalSince(start)
                if let currentAverage = averageCompletionTime {
                    let totalTasks = Double(tasksCompleted)
                    averageCompletionTime = (currentAverage * (totalTasks - 1) + completionTime) / totalTasks
                } else {
                    averageCompletionTime = completionTime
                }
            }
        } else if assignment.status == "failed" {
            self.tasksFailed += 1
            self.currentStreak = 0
        }
        
        self.lastUpdated = Date()
    }
}
