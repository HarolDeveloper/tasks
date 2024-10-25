import SwiftUI
import SwiftData

struct RegularTaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddTask = false
    @State private var selectedCategory = "Limpieza"
    @State private var showingCompletedTasks = false
    @State private var viewModel: TaskListViewModel?
    
    // Agregamos una consulta de SwiftData para verificar que los datos están llegando
    @Query private var taskItems: [TaskItem]
    
    var body: some View {
        Group {
            if let viewModel = viewModel {
                TaskListContent(
                    viewModel: viewModel,
                    showingAddTask: $showingAddTask,
                    showingCompletedTasks: $showingCompletedTasks
                )
            } else {
                ProgressView("Cargando...")
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = TaskListViewModel(modelContext: modelContext)
            }
        }
    }
}

private struct TaskListContent: View {
    let viewModel: TaskListViewModel
    @Binding var showingAddTask: Bool
    @Binding var showingCompletedTasks: Bool
    
    var body: some View {
        List {
            Section {
                let tasks = showingCompletedTasks ?
                    viewModel.getTaskItemsByStatus("completed") :
                    viewModel.getTaskItemsByStatus("pending")
                
                if tasks.isEmpty {
                    Text(showingCompletedTasks ? "No hay tareas completadas" : "No hay tareas pendientes")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(tasks) { taskItem in
                        TaskListRow(taskItem: taskItem) {
                            viewModel.updateTaskStatus(
                                taskItem: taskItem,
                                newStatus: taskItem.status == "completed" ? "pending" : "completed"
                            )
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.deleteTaskItem(taskItem)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            } header: {
                Text(showingCompletedTasks ? "Completadas" : "Pendientes")
            }
        }
        .navigationTitle("Mis Tareas")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    showingAddTask = true
                }) {
                    Image(systemName: "plus")
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    showingCompletedTasks.toggle()
                }) {
                    Image(systemName: showingCompletedTasks ? "list.bullet" : "checkmark.circle")
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(viewModel: viewModel)
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: TaskListViewModel
    
    @State private var title = ""
    @State private var description = ""
    @State private var priority = 1
    @State private var dueDate = Date()
    @State private var selectedCategory: TaskCategory?
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Título", text: $title)
                TextField("Descripción", text: $description)
                Picker("Prioridad", selection: $priority) {
                    Text("Alta").tag(1)
                    Text("Media").tag(2)
                    Text("Baja").tag(3)
                }
                DatePicker("Fecha límite", selection: $dueDate, displayedComponents: .date)
            }
            .navigationTitle("Nueva Tarea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        viewModel.addTaskItem(
                            title: title,
                            description: description,
                            priority: priority,
                            dueDate: dueDate,
                            category: selectedCategory
                        )
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

struct TaskListRow: View {
    let taskItem: TaskItem
    let onUpdate: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button(action: onUpdate) {
                    Image(systemName: taskItem.status == "completed" ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(taskItem.status == "completed" ? .green : .gray)
                }
                
                Text(taskItem.title)
                    .font(.headline)
                    .strikethrough(taskItem.status == "completed")
                
                Spacer()
                
                // Badge de prioridad
                Text(priorityText(taskItem.priority))
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(priorityColor(taskItem.priority))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            
            if let description = taskItem.taskDescription {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                if let category = taskItem.category {
                    Label(category.name, systemImage: category.icon)
                        .font(.caption)
                }
                Spacer()
                if let dueDate = taskItem.dueDate {
                    Text(dueDate, style: .date)
                        .font(.caption)
                }
            }
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    private func priorityText(_ priority: Int) -> String {
        switch priority {
        case 1: return "Alta"
        case 2: return "Media"
        case 3: return "Baja"
        default: return "Normal"
        }
    }
    
    private func priorityColor(_ priority: Int) -> Color {
        switch priority {
        case 1: return .red
        case 2: return .orange
        case 3: return .blue
        default: return .gray
        }
    }
}

// Preview
#Preview {
    // Crear un ModelContainer para el preview
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TaskItem.self, TaskCategory.self, configurations: config)
    
    // Agregar algunos datos de ejemplo
    let category = TaskCategory(
        name: "Limpieza",
        estimatedDuration: 60,
        points: 10,
        icon: "spray.sparkle.fill"
    )
    container.mainContext.insert(category)
    
    let task = TaskItem(
        title: "Tarea de ejemplo",
        taskDescription: "Esta es una tarea de ejemplo",
        status: "pending",
        priority: 1,
        createdAt: Date(),
        dueDate: Date().addingTimeInterval(86400),
        category: category
    )
    container.mainContext.insert(task)
    
    // Retornar la vista con el container
    return NavigationStack {
        RegularTaskListView()
    }
    .modelContainer(container)
}
