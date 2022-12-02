//
//  CreateNoteView.swift
//  Notes
//
//  Created by Garrit Schaap on 2022-11-14.
//

import SwiftUI

struct CreateNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var headlineText = ""
    @State private var mainText = ""
    @State private var errorText = ""
    @State private var showError = false
    @State private var showDismissWarning = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Headline", text: $headlineText)
                    TextField("Note", text: $mainText, axis: .vertical)
                        .lineLimit(6, reservesSpace: true)
                }
                Button {
                    addItem()
                    dismiss()
                } label: {
                    Text("Save")
                }
                
            }
            .navigationTitle("New note")
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
    
    private func addItem() {
        withAnimation {
            let newNote = Note(context: viewContext)
            newNote.text = mainText
            newNote.headline = headlineText
            newNote.updatedAt = Date()
            newNote.createdAt = Date()

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

struct CreateNoteView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNoteView()
    }
}
