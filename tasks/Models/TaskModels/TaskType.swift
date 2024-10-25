import SwiftData
import Foundation

@Model
class TaskType: Identifiable, Codable {
    @Attribute(.unique) var id: UUID
    var name: String
    var estimatedDuration: Int
    var points: Int
    var icon: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case estimatedDuration
        case points
        case icon
    }
    
    init(name: String, estimatedDuration: Int, points: Int, icon: String) {
        self.id = UUID()
        self.name = name
        self.estimatedDuration = estimatedDuration
        self.points = points
        self.icon = icon
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Convert string ID to UUID if needed
        if let idString = try? container.decode(String.self, forKey: .id) {
            self.id = UUID(uuidString: idString) ?? UUID()
        } else {
            self.id = UUID()
        }
        
        self.name = try container.decode(String.self, forKey: .name)
        self.estimatedDuration = try container.decode(Int.self, forKey: .estimatedDuration)
        self.points = try container.decode(Int.self, forKey: .points)
        self.icon = try container.decode(String.self, forKey: .icon)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(estimatedDuration, forKey: .estimatedDuration)
        try container.encode(points, forKey: .points)
        try container.encode(icon, forKey: .icon)
    }
}
