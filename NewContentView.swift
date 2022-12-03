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
    @State var selectedPriority: FrequencyPicker = .daily
    @State var filteredArray: [TaskObject] = []
    
    var body: some View {
        NavigationStack {
            
            
            PickerFrequency(selectedFrequency: $selectedPriority)
            List {
                ForEach(filteredArray) { task in
                    HStack {
                        Button {
                            task.isComplete = true
                            saveItems()
                        } label: {
                            if !task.isComplete {
                                Image(systemName: "circle")
                            } else if task.isComplete {
                                Image(systemName: "circle.fill")
                            }
                        }
                        Text(task.name ?? "")
                        Text(task.frequency ?? "")
                        Text(task.category ?? "")
                    }
                    
                    
                    
                    /*     .alert("Complete task?", isPresented: $showConfirmationMessage) {
                     Button(role: .destructive) {
                     task.isComplete = true
                     } label: {
                     Text("Yes")
                     }
                     } */
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
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
                        NewTestView()
                    } label: {
                        Image(systemName: "person.fill")
                    }
                    
                }
            }
            .sheet(isPresented: $showNewTaskSheet) {
                CreateNewTaskView()
            }
        }
        
        .onAppear {
            print("TET")
            updateFilteredArray()
        }
        .onChange(of: selectedPriority, perform: { newValue in
            updateFilteredArray()
        })
    }
    
    private func updateFilteredArray() {
        filteredArray = taskObjects.filter({ task in
            return task.frequency == selectedPriority.rawValue
        })
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
    
    private func saveItems() {
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

struct NewContentView_Previews: PreviewProvider {
    static var previews: some View {
        NewContentView()
    }
}
