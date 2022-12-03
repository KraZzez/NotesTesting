//
//  CreateNewTask.swift
//  Notes
//
//  Created by Ludvig Krantzén on 2022-12-02.
//

import SwiftUI

struct CreateNewTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var taskNameText = ""
    @State private var mainText = ""
    @State private var errorText = ""
    @State private var showError = false
    @State private var showDismissWarning = false
    @State var selectedPriority: FrequencyPicker = .daily
    @State var selectedCategory = "Fitness"
    
    @State var showPresetTasks = false
    @State var categoryToImage = Categories()
    @State private var showCreatePresetTaskWarning = false
    @State private var selectedPresetTaskName = ""
    @State private var selectedPresetTaskCategory = ""
    
    let presetTasks: [TaskTemplate] = [
    TaskTemplate(name: "Go to the gym", category: "Fitness"),
    TaskTemplate(name: "Buy Groceries", category: "Chores"),
    TaskTemplate(name: "Walk the dog", category: "Health")
    ]
    
    let categories = ["Fitness", "Shopping", "Chores", "Cooking", "Study"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    HStack {
                        TextField("TaskName...", text: $taskNameText)
                        Picker("", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    PickerFrequency(selectedFrequency: $selectedPriority)
                    
                    Button {
                        showPresetTasks.toggle()
                    } label: {
                        Text("Choose a preset task!")
                    }
                    
                    if showPresetTasks {
                        ScrollView(.horizontal, showsIndicators: true, content: {
                            HStack {
                                ForEach(presetTasks) { task in
                                    Button {
                                        selectedPresetTaskName = task.name
                                        selectedPresetTaskCategory = task.category
                                        showCreatePresetTaskWarning.toggle()
                                    } label: {
                                        VStack {
                                            Text(task.name)
                                            Image(systemName: "\(categoryToImage.getCategoryImage(category: task.category))")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                        }
                                        .bold()
                                        .padding(40)
                                        .background(.mint)
                                        .cornerRadius(10)
                                        .foregroundColor(.black)
                                    }
                                    .alert("Couldn't save your note", isPresented: $showError) {
                                        Text(errorText)
                                    }
                                    .alert("You sure you want to add this task?", isPresented: $showCreatePresetTaskWarning) {
                                        HStack {
                                            Button {
                                                addItem(category: selectedPresetTaskCategory, taskName: selectedPresetTaskName)
                                                dismiss()
                                            } label: {
                                                Text("Yes")
                                            }
                                            Button {
                                                
                                            } label: {
                                                Text("No")
                                            }
                                        }
                                    }
                                }
                            }
                        })
                    }

                    
                }
                Button {
                    addItem()
                    dismiss()
                } label: {
                    Text("Save")
                }
                
            }
            .navigationTitle("New task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    showDismissWarning.toggle()
                } label: {
                    Label("Close", systemImage: "xmark")
                }
            }
            .alert("Couldn't save your note", isPresented: $showError) {
                Text(errorText)
            }
            .alert("You have unsaved changes", isPresented: $showDismissWarning) {
                Button(role: .destructive) {
                    dismiss()
                } label: {
                    Text("Yes")
                }
            }
        }
    }
    
    private func addItem(category: String, taskName: String) {
        withAnimation {
            let newTaskObject = TaskObject(context: viewContext)
            newTaskObject.name = taskName
            newTaskObject.createdAt = Date()
            newTaskObject.category = category
            newTaskObject.frequency = selectedPriority.rawValue
            newTaskObject.isComplete = false
            newTaskObject.points = 2

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                errorText = nsError.localizedDescription
                showError.toggle()
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newTaskObject = TaskObject(context: viewContext)
            newTaskObject.name = taskNameText
            newTaskObject.createdAt = Date()
            newTaskObject.category = selectedCategory
            newTaskObject.frequency = selectedPriority.rawValue
            newTaskObject.isComplete = false
            newTaskObject.points = 1
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                errorText = nsError.localizedDescription
                showError.toggle()
            }
        }
    }

    
}

struct CreateNewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewTaskView()
    }
}

struct TaskTemplate: Identifiable {
    var id = UUID()
    
    var name: String
    var category: String
}
