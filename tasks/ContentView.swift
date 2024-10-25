// ContentView.swift
import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var userViewModel: UserViewModel
    
    init(userViewModel: UserViewModel) {
        _userViewModel = StateObject(wrappedValue: userViewModel)
    }
    
    var body: some View {
        if userViewModel.isLoading {
            LoadingView()
        } else if let error = userViewModel.error {
            ErrorView(error: error) {
                userViewModel.retryLoading()
            }
        } else {
            MainTabView(userViewModel: userViewModel)
        }
    }
}

// MARK: - Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let container = try! ModelContainer(
            for: Schema([
                User.self,
                Task.self,
                HousingGroup.self,
                UserProfile.self,
                RoommateUserStats.self,
                TaskType.self,
                RoommateTaskAssignment.self,
                HouseholdMember.self,
                UserCalendar.self,
                CalendarEvent.self,
                UserAvailabilitySlot.self,
                PointHistory.self
            ]),
            configurations: [
                ModelConfiguration(isStoredInMemoryOnly: true)
            ]
        )
        
        let userState = UserState()
        let viewModel = UserViewModel(
            userState: userState,
            modelContext: container.mainContext
        )
        
        ContentView(userViewModel: viewModel)
            .modelContainer(container)
    }
}



