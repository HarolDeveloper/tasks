import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var tasksViewModel: TasksViewModel?
    @State private var selectedDate = Date()
    
    private let calendar = Calendar.current
    private let daysInWeek = 7
    private let weeksToShow = 6
    
    var body: some View {
        Group {
            if let viewModel = tasksViewModel {
                calendarContent(viewModel)
                    .refreshable {
                        await viewModel.refresh()
                    }
            } else {
                ProgressView()
                    .onAppear {
                        tasksViewModel = TasksViewModel(modelContext: modelContext)
                    }
            }
        }
    }
    
    private func calendarContent(_ viewModel: TasksViewModel) -> some View {
        VStack(spacing: 20) {
            // Month selector
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                }
                
                Text(monthYearString)
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            
            // Weekday headers
            HStack {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .frame(maxWidth: .infinity)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // Calendar grid
            VStack(spacing: 2) {
                ForEach(monthDates, id: \.startDate) { week in
                    WeekView(
                        week: week,
                        selectedDate: $selectedDate,
                        assignments: viewModel.assignments
                    )
                }
            }
            
            // Selected date tasks
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Tareas para \(formatDate(selectedDate))")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    let tasksForDate = tasksForSelectedDate(in: viewModel)
                    if tasksForDate.isEmpty {
                        Text("No hay tareas para este día")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(tasksForDate) { assignment in
                            TaskRowView(assignment: assignment)
                        }
                    }
                }
                .padding(.top)
            }
        }
        .padding()
        .navigationTitle("Calendario")
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: selectedDate).capitalized
    }
    
    private var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.veryShortWeekdaySymbols
    }
    
    private var monthDates: [WeekDates] {
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let offsetDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        let startDate = calendar.date(byAdding: .day, value: -offsetDays, to: startOfMonth)!
        
        return (0..<weeksToShow).map { weekIndex in
            let weekStartDate = calendar.date(byAdding: .day, value: weekIndex * 7, to: startDate)!
            return WeekDates(
                startDate: weekStartDate,
                dates: (0..<7).map { dayOffset in
                    calendar.date(byAdding: .day, value: dayOffset, to: weekStartDate)!
                }
            )
        }
    }
    
    private func tasksForSelectedDate(in viewModel: TasksViewModel) -> [RoommateTaskAssignment] {
        viewModel.assignments.filter { assignment in
            guard let scheduledStart = assignment.scheduledStart else { return false }
            return calendar.isDate(scheduledStart, inSameDayAs: selectedDate)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d 'de' MMMM"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: date)
    }
    
    private func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

struct WeekDates {
    let startDate: Date
    let dates: [Date]
}

struct WeekView: View {
    let week: WeekDates
    @Binding var selectedDate: Date
    let assignments: [RoommateTaskAssignment]
    private let calendar = Calendar.current
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(week.dates, id: \.self) { date in
                DayCell(
                    date: date,
                    isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                    isCurrentMonth: calendar.isDate(date, equalTo: selectedDate, toGranularity: .month),
                    hasAssignments: hasAssignments(for: date)
                )
                .onTapGesture {
                    selectedDate = date
                }
            }
        }
    }
    
    private func hasAssignments(for date: Date) -> Bool {
        assignments.contains { assignment in
            guard let scheduledStart = assignment.scheduledStart else { return false }
            return calendar.isDate(scheduledStart, inSameDayAs: date)
        }
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    let hasAssignments: Bool
    private let calendar = Calendar.current
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isSelected ? Color.blue : Color.clear)
                .opacity(0.3)
            
            VStack {
                Text("\(calendar.component(.day, from: date))")
                    .font(.system(size: 16))
                    .foregroundColor(isCurrentMonth ? .primary : .gray)
                
                if hasAssignments {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 6, height: 6)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fit)
    }
}

struct TaskRowView: View {
    let assignment: RoommateTaskAssignment
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(assignment.task?.title ?? "Sin título")
                    .font(.headline)
                Text(assignment.assignedUserDisplayName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if let taskType = assignment.task?.taskType {
                Image(systemName: taskType.icon)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
