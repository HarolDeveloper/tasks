import SwiftData
import Foundation

// MARK: - Points and Stats Models
@Model
class PointHistory {
    var id: UUID
    var points: Int
    var reason: String?
    var createdAt: Date
    
    @Relationship var user: User?
    @Relationship var assignment: RoommateTaskAssignment?
    
    init(points: Int) {
        self.id = UUID()
        self.points = points
        self.createdAt = Date()
        self.reason = nil
    }
}
