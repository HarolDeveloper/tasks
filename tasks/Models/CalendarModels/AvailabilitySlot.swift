import SwiftData
import Foundation


@Model
class UserAvailabilitySlot {
    var id: UUID
    var startTime: Date
    var endTime: Date
    var status: String
    var calculatedAt: Date
    
    // Relationship
    @Relationship var user: User?
    
    init(startTime: Date, endTime: Date, status: String) {
        self.id = UUID()
        self.startTime = startTime
        self.endTime = endTime
        self.status = status
        self.calculatedAt = Date()
    }
}
