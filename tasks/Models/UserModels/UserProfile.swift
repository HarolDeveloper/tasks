import SwiftData
import Foundation

@Model
class UserProfile: Codable {
    var id: UUID
    var firstName: String?
    var lastName: String?
    var phone: String?
    var preferences: [String: String]
    
    @Relationship var user: User?
    
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, phone, preferences
    }
    
    init(firstName: String? = nil, lastName: String? = nil, phone: String? = nil) {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.preferences = [:]
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        preferences = try container.decode([String: String].self, forKey: .preferences)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encode(preferences, forKey: .preferences)
    }
}
