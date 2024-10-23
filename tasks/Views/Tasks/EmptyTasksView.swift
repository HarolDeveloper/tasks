//
//  EmptyTasksView.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 23/10/24.
//

import SwiftUI

struct EmptyTasksView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("¡No hay tareas para hoy!")
                .font(.system(.body, weight: .medium))
                .foregroundColor(.gray)
            
            Text("Añade nuevas tareas usando el botón +")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}


#Preview {
    EmptyTasksView()
}
