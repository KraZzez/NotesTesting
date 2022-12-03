//
//  ContentView.swift
//  Notes
//
//  Created by Garrit Schaap on 2022-11-14.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showNewNoteSheet = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.updatedAt, ascending: false)],
        animation: .default)
    private var notes: FetchedResults<Note>

    var body: some View {
        NavigationStack {
            List {
                ForEach(notes) { note in
                    NavigationLink(value: note) {
                        Text(note.headline ?? "")
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
                        showNewNoteSheet.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showNewNoteSheet) {
                CreateNoteView()
            }
            .navigationDestination(for: Note.self) { note in
                VStack {
                    Text(note.text ?? "")
                }
                .navigationTitle(note.headline ?? "")
            }
            Text("Select an item")
        }
    }

 /*   private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    } */

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { notes[$0] }.forEach(viewContext.delete)

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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .full
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
