//
//  HistoryTaskCard.swift
//  tasks
//
//  Created by Valente Alvarez on 23/10/24.
//

import SwiftUI
import Foundation

struct HistoryTaskCard: View {
    let taskAuthor: User? = nil
    let taskTitle: String
    let taskDateTime: String
    
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(1/1, contentMode: .fit)
                .frame(height: 50.0)
                .foregroundColor(Color.blue)
                .padding(.trailing, 10)
            
            VStack(alignment: .leading) {
                Text(taskAuthor?.username ?? "No user")
                    .font(.subheadline.bold())
                Text(taskTitle)
                    .font(.title2)
                
                Text(taskDateTime)
                
            }
            
            Spacer()
            
            Button("Comments", systemImage: "message.fill") {
                /* TBD */
            }
            .labelStyle(.iconOnly)
            .font(.title)
                
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 15)
    }

}

// Random, hard-coded values for testing the view's appearance
#Preview {
    HistoryTaskCard(
        taskTitle: "Random Title of task", taskDateTime: "23 December 2023, 10:23 PM")
}
