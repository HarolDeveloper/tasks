//
//  ProfileView.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 24/10/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel: UserViewModel
    
    var body: some View {
        Form {
            if let profile = viewModel.userProfile {
                Section("Información Personal") {
                    TextField("Nombre", text: .init(
                        get: { profile.firstName ?? "" },
                        set: { viewModel.updateProfile(
                            firstName: $0,
                            lastName: profile.lastName,
                            phone: profile.phone
                        )}
                    ))
                }
            }
            
            if let stats = viewModel.userStats {
                Section("Estadísticas") {
                    Text("Puntos: \(stats.totalPoints)")
                    Text("Tareas Completadas: \(stats.tasksCompleted)")
                }
            }
        }
    }
}


