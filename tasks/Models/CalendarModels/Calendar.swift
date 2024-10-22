import SwiftData
import Foundation


// MARK: - Calendar Models
@Model
class UserCalendar {
    var id: UUID
    var calendarName: String
    var calendarType: String
    var externalCalendarId: String?
    var lastSync: Date?
    
    @Relationship var user: User?
    @Relationship(deleteRule: .cascade) var events: [CalendarEvent]
    
    init(calendarName: String, calendarType: String) {
        self.id = UUID()
        self.calendarName = calendarName
        self.calendarType = calendarType
        self.events = []
    }
}
