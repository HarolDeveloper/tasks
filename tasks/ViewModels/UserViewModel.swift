//
//  UserViewModel.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 23/10/24.
//

import SwiftUI
import SwiftData
import Foundation

class UserViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var isRefreshing = false
    @Published private(set) var currentUser: User?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    // MARK: - Private Properties
    private let userState: UserState
    private let modelContext: ModelContext
    
    // MARK: - Initialization
    init(userState: UserState, modelContext: ModelContext) {
        self.userState = userState
        self.modelContext = modelContext
        loadInitialState()
    }
    
    // MARK: - State Management
    private func loadInitialState() {
        userState.initialize(with: modelContext)
        updateFromUserState()
    }
    
    private func updateFromUserState() {
        currentUser = userState.currentUser
        isLoading = userState.isLoading
        error = userState.error
    }
    
    // MARK: - Computed Properties
    var username: String {
        currentUser?.username ?? "Guest"
    }
    
    var userProfile: UserProfile? {
        currentUser?.profile
    }
    
    var userStats: RoommateUserStats? {
        currentUser?.stats
    }
    
    var displayName: String {
        if let firstName = userProfile?.firstName,
           let lastName = userProfile?.lastName {
            return "\(firstName) \(lastName)"
        } else if let firstName = userProfile?.firstName {
            return firstName
        } else {
            return username
        }
    }
    
    var totalPoints: Int {
        userStats?.totalPoints ?? 0
    }
    
    
    var hasProfile: Bool {
        userProfile != nil
    }
    
    // MARK: - User Actions
    func retryLoading() {
        userState.initialize(with: modelContext)
        updateFromUserState()
    }
    
    
    func updateProfile(firstName: String?, lastName: String?, phone: String?) {
            userState.updateProfile(firstName: firstName, lastName: lastName, phone: phone)
        }
    

}
