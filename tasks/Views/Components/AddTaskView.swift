//
//  AddTaskView.swift
//  tasks
//
//  Created by Valente Alvarez on 24/10/24.
//

import SwiftUI


struct AddTaskView: View {
	@State private var taskTitle: String = ""
	@State private var taskDescription: String = ""
	@State private var hasDueDate: Bool = false
	
	var taskTypes: [String] = ["Limpieza", "Compras", "Servicios"]
	@State var selectedTaskType: String
	@State private var selectedPriority: String = "No importante"
	@State private var date: Date = Date.now
	
    var body: some View {
		Form {
			Section(header: Text("Datos de Tarea")) {
				TextField("Nombre", text: $taskTitle)
				TextField("Descripción", text: $taskDescription)
				Picker("Tipo de tarea", selection: $selectedTaskType) {
					Text(taskTypes[0]).tag(taskTypes[0])
					Text(taskTypes[1]).tag(taskTypes[1])
					Text(taskTypes[2]).tag(taskTypes[2])
				}
				Picker("Prioridad", selection: $selectedPriority) {
					Text("Urgente").tag("Urgente")
					Text("Media").tag("Media")
					Text("No importante").tag("No importante")
				}
				
			}
			
			Toggle(isOn: $hasDueDate) {
				Text("Agregar fecha")
			}
			if hasDueDate {
				DatePicker("Fecha a completar la tarea", selection: $date, in: Date.now...)
					.datePickerStyle(GraphicalDatePickerStyle())
			}
			
		}
		
		Button("Agregar Tarea") { /* Agrear tarea */  }
		
    }
}

#Preview {
	AddTaskView(selectedTaskType: "pick")
}
