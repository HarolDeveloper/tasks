//
//  UserViewModel.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 23/10/24.
//

import SwiftUI
import SwiftData
import Foundation

@Observable
class UserViewModel {
    private let userState: UserState
    private let modelContext: ModelContext
    
    init(userState: UserState, modelContext: ModelContext) {
        self.userState = userState
        self.modelContext = modelContext
    }
    
    // MARK: - Computed Properties
    var currentUser: User? {
        userState.currentUser
    }
    
    var isLoading: Bool {
        userState.isLoading
    }
    
    var error: Error? {
        userState.error
    }
    
    var username: String {
        currentUser?.username ?? ""
    }
    
    var userProfile: UserProfile? {
        currentUser?.profile
    }
    
    var userStats: RoommateUserStats? {
        currentUser?.stats
    }
    
    // MARK: - User Actions
    func updateProfile(firstName: String?, lastName: String?, phone: String?) {
        userState.updateProfile(firstName: firstName, lastName: lastName, phone: phone)
    }
    
    func updatePreferences(_ preferences: [String: String]) {
        userState.updatePreferences(preferences)
    }
    
    func retryLoading() {
        userState.initialize(with: modelContext)
    }
}
