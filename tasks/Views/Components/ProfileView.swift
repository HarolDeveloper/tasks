//
//  ProfileView.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 24/10/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        Form {
            if let profile = userViewModel.userProfile {
                Section("Información Personal") {
                    TextField("Nombre", text: .init(
                        get: { profile.firstName ?? "" },
                        set: { userViewModel.updateProfile(
                            firstName: $0,
                            lastName: profile.lastName,
                            phone: profile.phone
                        )}
                    ))
                }
            }
            
            if let stats = userViewModel.userStats {
                Section("Estadísticas") {
                    Text("Puntos: \(stats.totalPoints)")
                    Text("Tareas Completadas: \(stats.tasksCompleted)")
                }
            }
        }
    }
}

