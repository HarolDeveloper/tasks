//
//  LoadingView.swift
//  tasks
//
//  Created by H Lancheros Alvarez on 24/10/24.
//

import SwiftUI

// MARK: - Loading Views
struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Logo o Ícono
            Image(systemName: "house.fill")
                .font(.system(size: 70))
                .foregroundStyle(.blue)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true),
                          value: isAnimating)
            
            // Título de la App
            Text("Roommate")
                .font(.title)
                .fontWeight(.bold)
            
            // Mensaje de carga
            VStack(spacing: 8) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.blue)
                    .padding(.bottom, 8)
                
                Text("Cargando tus datos")
                    .font(.headline)
                
                Text("Esto puede tomar unos segundos")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    LoadingView()
}
