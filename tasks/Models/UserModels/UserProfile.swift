import SwiftData
import Foundation

@Model
class UserProfile {
    var id: UUID
    var firstName: String?
    var lastName: String?
    var phone: String?
    var preferences: [String: String] // JSON encoded preferences
    
    // Relationship
    @Relationship var user: User?
    
    init(firstName: String? = nil, lastName: String? = nil, phone: String? = nil) {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.preferences = [:]
    }
}
