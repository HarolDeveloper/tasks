import SwiftUI
import SwiftData


struct ProfileView: View {
    @ObservedObject var userViewModel: UserViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var isEditingProfile = false
    @State private var showingPreferences = false
    @State private var selectedTab = 0
    
    private var backgroundStyle: Color {
        colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hero Section
                heroSection
                
                // Stats Cards
                statsOverview
                
                // Segmented Control
                Picker("Vista", selection: $selectedTab) {
                    Text("Perfil").tag(0)
                    Text("Logros").tag(1)
                    Text("Preferencias").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Tab Content
                Group {
                    switch selectedTab {
                    case 0:
                        profileContent
                    case 1:
                        achievementsContent
                    case 2:
                        preferencesContent
                    default:
                        EmptyView()
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut, value: selectedTab)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Mi Perfil")
        .sheet(isPresented: $isEditingProfile) {
            EditProfileSheet(userViewModel: userViewModel)
        }
    }
    
    // MARK: - Hero Section
    // MARK: - Hero Section
    private var heroSection: some View {
        ZStack {
            // Background Layers
            ZStack {
                // Base gradient
                Rectangle()
                    .fill(LinearGradient(
                        colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                
                // Decorative circles
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 150, height: 150)
                    .blur(radius: 20)
                    .offset(x: -100, y: -50)
                
                Circle()
                    .fill(Color.purple.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .blur(radius: 15)
                    .offset(x: 120, y: 30)
                
                // Pattern overlay
                HStack(spacing: 15) {
                    ForEach(0..<3) { i in
                        Rectangle()
                            .fill(Color.white.opacity(0.05))
                            .frame(width: 2)
                            .frame(maxHeight: .infinity)
                            .offset(x: CGFloat(i * 30))
                    }
                }
                .rotationEffect(.degrees(-30))
            }
            .frame(height: 260)
            
            // Content
            VStack(spacing: 12) {
                // Avatar Container
                ZStack {
                    // Outer ring
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.8),
                                    .white.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 100, height: 100)
                    
                    // Main circle with glass effect
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 110, height: 110)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    // User initial
                    Text(userViewModel.displayName.prefix(1).uppercased())
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                }
                
                // User Info
                VStack(spacing: 8) {
                    Text(userViewModel.displayName)
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                    
                    Text("@\(userViewModel.username)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.2))
                        .clipShape(Capsule())
                }
                
                // Edit Button
                Button(action: { isEditingProfile = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "pencil")
                        Text("Editar Perfil")
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .buttonStyle(ScaleButtonStyle())
            }
            .padding(.top, 24)
        }
        .ignoresSafeArea(edges: .top)
    }

    // Custom button style for scale effect
    struct ScaleButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.95 : 1)
                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
        }
    }
    
    // MARK: - Stats Overview
    private var statsOverview: some View {
        HStack(spacing: 16) {
            StatProfileCard(
                title: "Puntos",
                value: "\(userViewModel.totalPoints)",
                icon: "star.fill",
                color: .yellow,
                gradient: [.yellow, .orange]
            )
            
            StatProfileCard(
                title: "Tareas",
                value: "\(userViewModel.userStats?.tasksCompleted ?? 0)",
                icon: "checkmark.circle.fill",
                color: .green,
                gradient: [.green, .mint]
            )
            
            StatProfileCard(
                title: "Racha",
                value: "\(userViewModel.userStats?.currentStreak ?? 0)",
                icon: "flame.fill",
                color: .orange,
                gradient: [.orange, .red]
            )
        }
        .padding(.horizontal)
        .padding(.top, -30) // Overlap with hero section
    }
    
    // MARK: - Profile Content
    private var profileContent: some View {
        VStack(spacing: 20) {
            // Profile Details
            CardView {
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Detalles", icon: "person.fill")
                    
                    if let profile = userViewModel.userProfile {
                        InfoRow(
                            icon: "person.fill",
                            title: "Nombre",
                            value: profile.firstName ?? "-"
                        )
                        InfoRow(
                            icon: "person.text.rectangle.fill",
                            title: "Apellido",
                            value: profile.lastName ?? "-"
                        )
                        InfoRow(
                            icon: "phone.fill",
                            title: "Teléfono",
                            value: profile.phone ?? "-"
                        )
                    }
                }
            }
            
            // Additional Stats
            CardView {
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Estadísticas", icon: "chart.bar.fill")
                    
                    if let stats = userViewModel.userStats {
                        InfoRow(
                            icon: "xmark.circle.fill",
                            title: "Tareas Fallidas",
                            value: "\(stats.tasksFailed)"
                        )
                        InfoRow(
                            icon: "clock.fill",
                            title: "Tiempo Promedio",
                            value: formatTime(stats.averageCompletionTime ?? 0)
                        )
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Achievements Content
    private var achievementsContent: some View {
        VStack(spacing: 20) {
            // Featured Achievement
            if let stats = userViewModel.userStats {
                CardView {
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "crown.fill")
                                .font(.title)
                                .foregroundColor(.yellow)
                            Text("Logro Destacado")
                                .font(.headline)
                        }
                        
                        let progress = Double(stats.tasksCompleted) / 10.0
                        CircularProgressView(
                            progress: progress,
                            text: "\(Int(progress * 100))%"
                        )
                        .frame(width: 120, height: 120)
                        
                        Text("¡Casi llegas a Principiante!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
            
            // Achievement Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                AchievementCard(
                    title: "Principiante",
                    description: "Completar 10 tareas",
                    progress: Double(userViewModel.userStats?.tasksCompleted ?? 0) / 10.0
                )
                
                AchievementCard(
                    title: "Racha",
                    description: "Mantener racha 7 días",
                    progress: Double(userViewModel.userStats?.currentStreak ?? 0) / 7.0
                )
                
                AchievementCard(
                    title: "Experto",
                    description: "100 puntos",
                    progress: Double(userViewModel.userStats?.totalPoints ?? 0) / 100.0
                )
                
                AchievementCard(
                    title: "Velocista",
                    description: "Completar tarea en 1h",
                    progress: 0.3
                )
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Preferences Content
    private var preferencesContent: some View {
        VStack(spacing: 20) {
            CardView {
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Preferencias", icon: "gear")
                    
                    if let preferences = userViewModel.userProfile?.preferences {
                        ForEach(Array(preferences.keys.sorted()), id: \.self) { key in
                            InfoRow(
                                icon: getPreferenceIcon(for: key),
                                title: key.capitalized,
                                value: preferences[key] ?? "-"
                            )
                        }
                    }
                    
                    Button(action: { showingPreferences = true }) {
                        Label("Configurar", systemImage: "slider.horizontal.3")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Helper Functions
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        return "\(hours)h \(minutes)m"
    }
    
    private func getPreferenceIcon(for key: String) -> String {
        switch key.lowercased() {
        case "theme": return "paintbrush.fill"
        case "notifications": return "bell.fill"
        default: return "gearshape.fill"
        }
    }
}

// MARK: - Supporting Views
struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct CircularProgressView: View {
    let progress: Double
    let text: String
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 8)
            
            Circle()
                .trim(from: 0, to: min(progress, 1.0))
                .stroke(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
            
            Text(text)
                .font(.title2.bold())
                .foregroundColor(.primary)
        }
    }
}

struct StatProfileCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let gradient: [Color]
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            Text(value)
                .font(.title2.bold())
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        Label(title, systemImage: icon)
            .font(.title3.bold())
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .bold()
        }
    }
}

struct AchievementCard: View {
    let title: String
    let description: String
    let progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "trophy.fill")
                    .font(.title2)
                    .foregroundColor(.yellow)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
            }
            
            Text(title)
                .font(.headline)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
            
            ProgressView(value: min(progress, 1.0))
                .tint(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}


struct EditProfileSheet: View {
    @ObservedObject var userViewModel: UserViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var firstName: String
    @State private var lastName: String
    @State private var phone: String
    
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
        _firstName = State(initialValue: userViewModel.userProfile?.firstName ?? "")
        _lastName = State(initialValue: userViewModel.userProfile?.lastName ?? "")
        _phone = State(initialValue: userViewModel.userProfile?.phone ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Información Personal") {
                    TextField("Nombre", text: $firstName)
                    TextField("Apellido", text: $lastName)
                    TextField("Teléfono", text: $phone)
                }
            }
            .navigationTitle("Editar Perfil")
            .navigationBarItems(
                leading: Button("Cancelar") { dismiss() },
                trailing: Button("Guardar") {
                    userViewModel.updateProfile(
                        firstName: firstName,
                        lastName: lastName,
                        phone: phone
                    )
                    dismiss()
                }
            )
        }
    }}

// MARK: - Preview Provider
#Preview {
    NavigationView {
        ProfileView(userViewModel: UserViewModel(
            userState: UserState(),
            modelContext: ModelContext(try! ModelContainer(for: User.self))
        ))
    }
}
