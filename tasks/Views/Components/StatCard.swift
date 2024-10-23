//
//  StatCard.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 23/10/24.
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(color)
            
            Text("\(value)")
                .font(.title)
                .bold()
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}
