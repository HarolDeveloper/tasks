//
//  AppState.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 23/10/24.
//

import Foundation


@Observable
class AppState {
    static let shared = AppState()
    var currentUser: User?
    
    private init() {}
    
    func setCurrentUser(_ user: User) {
        self.currentUser = user
    }
}
