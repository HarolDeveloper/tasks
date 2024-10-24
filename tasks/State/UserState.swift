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
    
    private func loadUser() {
        guard let context = modelContext else {
            error = NSError(domain: "", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "ModelContext not initialized"])
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
                print("Loaded existing user: \(String(describing: currentUser?.username))")
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
                          userInfo: [NSLocalizedDescriptionKey: "Could not load user file"])
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let user = try decoder.decode(User.self, from: data)
            context.insert(user)
            currentUser = user
            try context.save()
            print("Successfully loaded initial user: \(user.username)")
        } catch {
            self.error = error
            print("Error decoding user data: \(error)")
        }
    }
    
    // Add profile update methods
    func updateProfile(firstName: String?, lastName: String?, phone: String?) {
        guard let context = modelContext,
              let currentUser = currentUser else {
            error = NSError(domain: "", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "ModelContext or User not initialized"])
            return
        }
        
        // Create profile if it doesn't exist
        if currentUser.profile == nil {
            let newProfile = UserProfile(firstName: firstName, lastName: lastName, phone: phone)
            currentUser.profile = newProfile
            context.insert(newProfile)
        } else {
            // Update existing profile
            currentUser.profile?.firstName = firstName
            currentUser.profile?.lastName = lastName
            currentUser.profile?.phone = phone
        }
        
        do {
            try context.save()
            print("Profile updated successfully")
        } catch {
            self.error = error
            print("Error updating profile: \(error)")
        }
    }
    
    func updatePreferences(_ preferences: [String: String]) {
        guard let context = modelContext,
              let currentUser = currentUser else {
            error = NSError(domain: "", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "ModelContext or User not initialized"])
            return
        }
        
        // Create profile if it doesn't exist
        if currentUser.profile == nil {
            let newProfile = UserProfile()
            newProfile.preferences = preferences
            currentUser.profile = newProfile
            context.insert(newProfile)
        } else {
            // Update existing preferences
            currentUser.profile?.preferences = preferences
        }
        
        do {
            try context.save()
            print("Preferences updated successfully")
        } catch {
            self.error = error
            print("Error updating preferences: \(error)")
        }
    }
}
