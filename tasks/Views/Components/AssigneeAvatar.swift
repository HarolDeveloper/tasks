//
//  AssigneeAvatar.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 23/10/24.
//

import SwiftUI

struct AssigneeAvatar: View {
    let assignment: RoommateTaskAssignment
    
    var body: some View {
        if let user = assignment.user {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 32, height: 32)
                .overlay(
                    Text(user.username.prefix(1).uppercased())
                        .font(.system(.caption, weight: .medium))
                        .foregroundColor(.gray)
                )
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
        }
    }
}

