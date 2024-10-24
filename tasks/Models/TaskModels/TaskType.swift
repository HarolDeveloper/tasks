import SwiftData
import Foundation


@Model
class TaskType: Identifiable, Codable {
    @Attribute(.unique) var id: UUID
    var name: String
    var taskDescription: String?
    var estimatedDuration: Int
    var points: Int
    var frequency: String?
    
    @Relationship(deleteRule: .cascade) var tasks: [Task]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case taskDescription
        case estimatedDuration
        case points
        case frequency
    }
    
    init(name: String, estimatedDuration: Int, points: Int) {
        self.id = UUID()
        self.name = name
        self.estimatedDuration = estimatedDuration
        self.points = points
        self.tasks = []
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        taskDescription = try container.decodeIfPresent(String.self, forKey: .taskDescription)
        estimatedDuration = try container.decode(Int.self, forKey: .estimatedDuration)
        points = try container.decode(Int.self, forKey: .points)
        frequency = try container.decodeIfPresent(String.self, forKey: .frequency)
        tasks = []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(taskDescription, forKey: .taskDescription)
        try container.encode(estimatedDuration, forKey: .estimatedDuration)
        try container.encode(points, forKey: .points)
        try container.encodeIfPresent(frequency, forKey: .frequency)
    }
}
