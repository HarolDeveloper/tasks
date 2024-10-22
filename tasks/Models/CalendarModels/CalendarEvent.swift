import SwiftData
import Foundation

@Model
class CalendarEvent {
    var id: UUID
    var title: String
    var eventDescription: String?
    var startTime: Date
    var endTime: Date
    var isRecurring: Bool
    var recurrenceRule: String?
    
    @Relationship var calendar: UserCalendar?
    
    init(title: String, startTime: Date, endTime: Date) {
        self.id = UUID()
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.isRecurring = false
        self.eventDescription = nil
        self.recurrenceRule = nil
    }
}
