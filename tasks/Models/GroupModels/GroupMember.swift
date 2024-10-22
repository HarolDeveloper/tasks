import SwiftData
import Foundation


@Model
class HouseholdMember { // Renamed from GroupMember
    var id: UUID
    var joinDate: Date
    var role: String
    
    // Relationships
    @Relationship var user: User?
    @Relationship var group: HousingGroup?
    
    init(role: String) {
        self.id = UUID()
        self.joinDate = Date()
        self.role = role
    }
}
