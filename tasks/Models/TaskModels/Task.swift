import SwiftData
import Foundation


// Task.swift
@Model
class Task: Identifiable, Codable {
    @Attribute(.unique) var id: UUID
    var title: String
    var taskDescription: String?
    var status: String
    var createdAt: Date
    var dueDate: Date?
    var priority: Int
    
    @Relationship var taskType: TaskType?
    @Relationship var group: HousingGroup?
    @Relationship(deleteRule: .cascade) var assignments: [RoommateTaskAssignment]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case taskDescription = "description" // Para coincidir con el JSON
        case status
        case createdAt
        case dueDate
        case priority
        case taskType
    }
    
    init(title: String, priority: Int) {
        self.id = UUID()
        self.title = title
        self.priority = priority
        self.status = "pending"
        self.createdAt = Date()
        self.assignments = []
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        taskDescription = try container.decodeIfPresent(String.self, forKey: .taskDescription)
        status = try container.decode(String.self, forKey: .status)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        dueDate = try container.decodeIfPresent(Date.self, forKey: .dueDate)
        priority = try container.decode(Int.self, forKey: .priority)
        taskType = try container.decodeIfPresent(TaskType.self, forKey: .taskType)
        assignments = []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(taskDescription, forKey: .taskDescription)
        try container.encode(status, forKey: .status)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(dueDate, forKey: .dueDate)
        try container.encode(priority, forKey: .priority)
        try container.encodeIfPresent(taskType, forKey: .taskType)
    }
}

