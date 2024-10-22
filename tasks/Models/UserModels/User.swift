import SwiftData
import Foundation

// MARK: - User Models
@Model
class User {
    var id: UUID
    var username: String
    var email: String
    var passwordHash: String
    var createdAt: Date
    var lastLogin: Date?
    var isActive: Bool
    
    // Relationships
    @Relationship(deleteRule: .cascade) var profile: UserProfile?
    @Relationship(deleteRule: .cascade) var calendars: [UserCalendar]
    @Relationship(deleteRule: .cascade) var groupMemberships: [HouseholdMember]
    @Relationship(deleteRule: .cascade) var taskAssignments: [RoommateTaskAssignment]
    @Relationship(deleteRule: .cascade) var availabilitySlots: [UserAvailabilitySlot]
    @Relationship(deleteRule: .cascade) var stats: RoommateUserStats?
    
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
}
