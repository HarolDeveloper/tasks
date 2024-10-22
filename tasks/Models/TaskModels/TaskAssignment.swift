import SwiftData
import Foundation


@Model
class RoommateTaskAssignment {
    var id: UUID
    var assignedAt: Date
    var scheduledStart: Date?
    var scheduledEnd: Date?
    var completedAt: Date?
    var status: String
    var pointsEarned: Int?
    
    @Relationship var task: Task?
    @Relationship var user: User?
    @Relationship(deleteRule: .cascade) var pointHistory: [PointHistory]
    
    init(status: String) {
        self.id = UUID()
        self.assignedAt = Date()
        self.status = status
        self.scheduledStart = nil
        self.scheduledEnd = nil
        self.completedAt = nil
        self.pointsEarned = nil
        self.pointHistory = []
    }
}
