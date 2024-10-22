import SwiftData
import Foundation


@Model
class HousingGroup {
    var id: UUID
    var groupName: String
    var createdAt: Date
    
    @Relationship(deleteRule: .cascade) var members: [HouseholdMember]
    @Relationship(deleteRule: .cascade) var tasks: [Task]
    
    init(groupName: String) {
        self.id = UUID()
        self.groupName = groupName
        self.createdAt = Date()
        self.members = []
        self.tasks = []
    }
}
