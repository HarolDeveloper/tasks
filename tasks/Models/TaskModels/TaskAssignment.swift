import SwiftData
import Foundation

@Model
class RoommateTaskAssignment: Codable {
    @Attribute(.unique) var id: UUID
    var assignedAt: Date
    var scheduledStart: Date?
    var scheduledEnd: Date?
    var completedAt: Date?
    var status: String
    var pointsEarned: Int?
    
    @Relationship var task: Task?
    @Relationship var assignedUserProfile: UserProfile?
    @Relationship(deleteRule: .cascade) var pointHistory: [PointHistory]
    
    enum CodingKeys: String, CodingKey {
        case id
        case assignedAt
        case scheduledStart
        case scheduledEnd
        case completedAt
        case status
        case pointsEarned
        case task
        case assignedUser // Esto mapea al assignedUserProfile en el JSON
    }
    
    init() {
        self.id = UUID()
        self.assignedAt = Date()
        self.status = "pending"
        self.pointHistory = []
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        id = try container.decode(UUID.self, forKey: .id)
        
        // Decodificar fechas
        if let dateString = try? container.decode(String.self, forKey: .assignedAt) {
            assignedAt = dateFormatter.date(from: dateString) ?? Date()
        } else {
            assignedAt = Date()
        }
        
        if let startString = try? container.decodeIfPresent(String.self, forKey: .scheduledStart) {
            scheduledStart = dateFormatter.date(from: startString)
        }
        
        if let endString = try? container.decodeIfPresent(String.self, forKey: .scheduledEnd) {
            scheduledEnd = dateFormatter.date(from: endString)
        }
        
        if let completedString = try? container.decodeIfPresent(String.self, forKey: .completedAt) {
            completedAt = dateFormatter.date(from: completedString)
        }
        
        status = try container.decode(String.self, forKey: .status)
        pointsEarned = try container.decodeIfPresent(Int.self, forKey: .pointsEarned)
        
        // Decodificar task
        let taskDTO = try container.decode(TaskDTO.self, forKey: .task)
        let task = Task(title: taskDTO.title, priority: taskDTO.priority)
        task.taskType = TaskType(name: taskDTO.taskType.name, estimatedDuration: taskDTO.taskType.estimatedDuration, points: taskDTO.taskType.points, icon: "spray.sparkle.fill")
        self.task = task
        
        // Decodificar userProfile
        let userProfileDTO = try container.decode(AssignedUserProfileDTO.self, forKey: .assignedUser)
        self.assignedUserProfile = userProfileDTO.toUserProfile()
        
        self.pointHistory = []
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
    }
    
    var assignedUserDisplayName: String {
        if let profile = assignedUserProfile {
            if let firstName = profile.firstName,
               let lastName = profile.lastName {
                return "\(firstName) \(lastName)"
            }
        }
        return "Sin asignar"
    }
}
