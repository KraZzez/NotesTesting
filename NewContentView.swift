//
//  NewContentView.swift
//  Notes
//
//  Created by Ludvig Krantzén on 2022-12-02.
//

import SwiftUI
import CoreData

struct NewContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showNewTaskSheet = false
    @State private var showPresetTaskSheet = false
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskObject.createdAt, ascending: false)],
        animation: .default)
    private var taskObjects: FetchedResults<TaskObject>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(taskObjects) { task in
                    
                    Button {
                        task.isComplete.toggle()
                    } label: {
                        if !task.isComplete {
                            Image(systemName: "circle")
                        } else if task.isComplete {
                            Image(systemName: "circle.fill")
                        }
                    }
                    NavigationLink(value: task) {
                        HStack {
                            
                            Divider()
                            Text(task.name ?? "")
                            Text(task.frequency ?? "")
                            Text(task.category ?? "")
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        showNewTaskSheet.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showNewTaskSheet) {
                CreateNewTask()
            }
            .navigationDestination(for: TaskObject.self) { task in
                VStack {
                    Text(task.name ?? "")
                }
                .navigationTitle(task.name ?? "")
            }
            Text("Select an item")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { taskObjects[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}

struct NewContentView_Previews: PreviewProvider {
    static var previews: some View {
        NewContentView()
    }
}
