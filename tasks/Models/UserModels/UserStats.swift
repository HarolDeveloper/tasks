import SwiftData
import Foundation


@Model
class RoommateUserStats {
    var id: UUID
    var totalPoints: Int
    var tasksCompleted: Int
    var tasksFailed: Int
    var currentStreak: Int
    var lastUpdated: Date
    var averageCompletionTime: TimeInterval?
    var preferredTaskTypes: [String: Int]
    
    // Relationship
    @Relationship var user: User?
    
    init() {
        self.id = UUID()
        self.totalPoints = 0
        self.tasksCompleted = 0
        self.tasksFailed = 0
        self.currentStreak = 0
        self.lastUpdated = Date()
        self.preferredTaskTypes = [:]
    }
    
    // Helper methods for statistics
    func updateStats(with assignment: RoommateTaskAssignment) {
        if assignment.status == "completed" {
            self.tasksCompleted += 1
            self.currentStreak += 1
            
            if let points = assignment.pointsEarned {
                self.totalPoints += points
            }
            
            // Update task type preferences
            if let taskType = assignment.task?.taskType?.name {
                preferredTaskTypes[taskType, default: 0] += 1
            }
            
            // Update average completion time
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
    
    // Calculate completion rate
    var completionRate: Double {
        let total = Double(tasksCompleted + tasksFailed)
        guard total > 0 else { return 0.0 }
        return Double(tasksCompleted) / total
    }
    
    // Get preferred task types sorted by frequency
    var sortedPreferredTaskTypes: [(type: String, count: Int)] {
        return preferredTaskTypes.sorted { $0.value > $1.value }
            .map { (type: $0.key, count: $0.value) }
    }
}
