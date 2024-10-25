import SwiftUI

struct UserHeaderView: View {
    // MARK: - Properties
    let profile: UserProfile
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Computed Properties
    private var backgroundStyle: Color {
        colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground)
    }
    
    private var welcomeMessage: String {
        "Bienvenido, \(profile.firstName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Usuario")"
    }
    
    private var gradientColors: [Color] {
        colorScheme == .dark
            ? [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]
            : [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]
    }
    
    // MARK: - View Builder Methods
    @ViewBuilder
    private func avatarView() -> some View {
        ZStack {
            Circle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: gradientColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 60, height: 60)
            
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
        }
    }
    
    @ViewBuilder
    private func userNameSection() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(welcomeMessage)
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundColor(.primary)
            
            if let lastName = profile.lastName?.trimmingCharacters(in: .whitespacesAndNewlines),
               !lastName.isEmpty {
                Text( profile.firstName! + " " + lastName)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
           
        }
    }
    
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                avatarView()
                userNameSection()
            }
            
            Divider()
            
            
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .background(
            backgroundStyle
                .cornerRadius(16)
               
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("User profile header")
    }
}


struct StatItemView: View {
    let icon: String
    let value: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 20))
            
            Text(value)
                .font(.system(.title3, design: .rounded, weight: .bold))
            
            Text(title)
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Preview Provider
#Preview {
    VStack {
        UserHeaderView(profile: UserProfile(firstName: "John", lastName: "Doe"))
            .padding()
        
        UserHeaderView(profile: UserProfile(firstName: "María", lastName: "García"))
            .padding()
    }
}
