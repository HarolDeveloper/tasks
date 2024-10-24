import SwiftData
import Foundation


@Model
class RoommateTaskAssignment: Identifiable, Codable {
    @Attribute(.unique) var id: UUID
    var assignedAt: Date
    var scheduledStart: Date?
    var scheduledEnd: Date?
    var completedAt: Date?
    var status: String
    var pointsEarned: Int?
    var taskId: String? // Add this property to store the taskId temporarily
    
    @Relationship var task: Task?
    @Relationship var user: User?
    @Relationship(deleteRule: .cascade) var pointHistory: [PointHistory]
    
    enum CodingKeys: String, CodingKey {
        case id
        case assignedAt
        case scheduledStart
        case scheduledEnd
        case completedAt
        case status
        case pointsEarned
        case taskId
    }
    
    init(status: String) {
        self.id = UUID()
        self.assignedAt = Date()
        self.status = status
        self.pointHistory = []
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        assignedAt = try container.decode(Date.self, forKey: .assignedAt)
        scheduledStart = try container.decodeIfPresent(Date.self, forKey: .scheduledStart)
        scheduledEnd = try container.decodeIfPresent(Date.self, forKey: .scheduledEnd)
        completedAt = try container.decodeIfPresent(Date.self, forKey: .completedAt)
        status = try container.decode(String.self, forKey: .status)
        pointsEarned = try container.decodeIfPresent(Int.self, forKey: .pointsEarned)
        taskId = try container.decodeIfPresent(String.self, forKey: .taskId)
        pointHistory = []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(assignedAt, forKey: .assignedAt)
        try container.encodeIfPresent(scheduledStart, forKey: .scheduledStart)
        try container.encodeIfPresent(scheduledEnd, forKey: .scheduledEnd)
        try container.encodeIfPresent(completedAt, forKey: .completedAt)
        try container.encode(status, forKey: .status)
        try container.encodeIfPresent(pointsEarned, forKey: .pointsEarned)
        try container.encodeIfPresent(taskId, forKey: .taskId)
    }
}
