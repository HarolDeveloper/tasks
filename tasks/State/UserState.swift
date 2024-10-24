//
//  UserState.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 24/10/24.
//

import SwiftUI
import SwiftData
import Foundation

@Observable
class UserState {
    @ObservationIgnored private(set) var modelContext: ModelContext?
    private(set) var currentUser: User?
    private(set) var isLoading = false
    private(set) var error: Error?
    
    init() {}
    
    func initialize(with modelContext: ModelContext) {
        self.modelContext = modelContext
        loadUser()
    }
    
    func reload() {
        guard modelContext != nil else {
            error = NSError(domain: "", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "ModelContext no inicializado"])
            return
        }
        loadUser()
    }
    
    private func loadUser() {
        guard let context = modelContext else {
            error = NSError(domain: "", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "ModelContext no inicializado"])
            return
        }
        
        isLoading = true
        error = nil
        
        do {
            let descriptor = FetchDescriptor<User>()
            let users = try context.fetch(descriptor)
            
            if users.isEmpty {
                loadInitialUser()
            } else {
                currentUser = users.first
            }
        } catch {
            self.error = error
            print("Error fetching user: \(error)")
        }
        
        isLoading = false
    }
    
    private func loadInitialUser() {
        guard let context = modelContext,
              let url = Bundle.main.url(forResource: "user", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            error = NSError(domain: "", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "No se pudo cargar el archivo de usuario"])
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let user = try decoder.decode(User.self, from: data)
            context.insert(user)
            print("-------")
            print(user)
            currentUser = user
            try context.save()
        } catch {
            self.error = error
            print("Error decoding user data: \(error)")
        }
    }
    
    func updateProfile(firstName: String?, lastName: String?, phone: String?) {
        guard let context = modelContext,
              let currentUser = currentUser,
              let profile = currentUser.profile else {
            error = NSError(domain: "", code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "No se pudo actualizar el perfil"])
            return
        }

        // Actualizar los datos del perfil
        profile.firstName = firstName
        profile.lastName = lastName
        profile.phone = phone

        // Guardar los cambios
        do {
            try context.save()
        } catch {
            self.error = error
            print("Error updating profile: \(error)")
        }
    }

    func updatePreferences(_ preferences: [String: String]) {
        guard let context = modelContext,
              let currentUser = currentUser,
              let profile = currentUser.profile else {
            error = NSError(domain: "", code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "No se pudo actualizar las preferencias"])
            return
        }

        // Actualizar preferencias
        profile.preferences = preferences

        // Guardar los cambios
        do {
            try context.save()
        } catch {
            self.error = error
            print("Error updating preferences: \(error)")
        }
    }
}
