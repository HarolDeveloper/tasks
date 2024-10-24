import SwiftData
import Foundation

// MARK: - User Models
@Model
class User: Codable {
    var id: UUID
    var username: String
    var email: String
    var passwordHash: String
    var createdAt: Date
    var lastLogin: Date?
    var isActive: Bool
    
    @Relationship(deleteRule: .cascade) var profile: UserProfile?
    @Relationship(deleteRule: .cascade) var calendars: [UserCalendar]
    @Relationship(deleteRule: .cascade) var groupMemberships: [HouseholdMember]
    @Relationship(deleteRule: .cascade) var taskAssignments: [RoommateTaskAssignment]
    @Relationship(deleteRule: .cascade) var availabilitySlots: [UserAvailabilitySlot]
    @Relationship(deleteRule: .cascade) var stats: RoommateUserStats?
    
    enum CodingKeys: String, CodingKey {
        case id, username, email, passwordHash, createdAt, lastLogin, isActive
        case profile, stats
    }
    
    init(username: String, email: String, passwordHash: String) {
        self.id = UUID()
        self.username = username
        self.email = email
        self.passwordHash = passwordHash
        self.createdAt = Date()
        self.isActive = true
        self.calendars = []
        self.groupMemberships = []
        self.taskAssignments = []
        self.availabilitySlots = []
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        passwordHash = try container.decode(String.self, forKey: .passwordHash)
        id = try container.decode(UUID.self, forKey: .id)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        lastLogin = try container.decodeIfPresent(Date.self, forKey: .lastLogin)
        isActive = try container.decode(Bool.self, forKey: .isActive)
        profile = try container.decodeIfPresent(UserProfile.self, forKey: .profile)
        stats = try container.decodeIfPresent(RoommateUserStats.self, forKey: .stats)
        
        calendars = []
        groupMemberships = []
        taskAssignments = []
        availabilitySlots = []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(email, forKey: .email)
        try container.encode(passwordHash, forKey: .passwordHash)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(lastLogin, forKey: .lastLogin)
        try container.encode(isActive, forKey: .isActive)
        try container.encodeIfPresent(profile, forKey: .profile)
        try container.encodeIfPresent(stats, forKey: .stats)
    }
}

