//
//  UserStatsCard.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 24/10/24.
//

import SwiftUI

struct UserHeaderView: View {
    let profile: UserProfile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Bienvenido, \(profile.firstName ?? "Usuario")")
                .font(.title2)
                .fontWeight(.bold)
            
            if let lastName = profile.lastName {
                Text(lastName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

