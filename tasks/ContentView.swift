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

// MARK: - Loading Views
struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Logo o Ícono
            Image(systemName: "house.fill")
                .font(.system(size: 70))
                .foregroundStyle(.blue)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true),
                          value: isAnimating)
            
            // Título de la App
            Text("Roommate")
                .font(.title)
                .fontWeight(.bold)
            
            // Mensaje de carga
            VStack(spacing: 8) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.blue)
                    .padding(.bottom, 8)
                
                Text("Cargando tus datos")
                    .font(.headline)
                
                Text("Esto puede tomar unos segundos")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Error View
struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
   
        VStack(spacing: 20) {
            // Ícono de error
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.red)
            
            // Mensajes de error
            VStack(spacing: 8) {
                Text("¡Ups! Algo salió mal")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(error.localizedDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            // Botón de reintentar
            Button(action: retryAction) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Reintentar")
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 8)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

// MARK: - Loading Card View (para usar en otras partes de la app)
struct LoadingCardView: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .tint(.blue)
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

