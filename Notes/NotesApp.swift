//
//  NotesApp.swift
//  Notes
//
//  Created by Ludvig Krantzén on 2022-12-02.
//

import SwiftUI

@main
struct NotesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NewContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
