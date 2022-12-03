//
//  NewTestView.swift
//  Notes
//
//  Created by Ludvig Krantzén on 2022-12-03.
//

import SwiftUI

struct NewTestView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \UserLevel.exp, ascending: false)],
        animation: .default)
    private var userLevel: FetchedResults<UserLevel>
    
    
    @State private var errorText = ""
    @State private var showError = false
    
    var body: some View {
        VStack {
            Text("Level: \(getCalculatedLevel())")
            Text("EXP: \(getUserExperience())")
        }
        .onAppear {
            if userLevel.count == 0 {
                let newUserLevel = UserLevel(context: viewContext)
                newUserLevel.exp = 0
                
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
    
    func updateLevel(points: Int16) {
        
    }
    
    func getCalculatedLevel() -> Int16 {
        return (userLevel[0].exp / 10 + 1)
    }
    
    func getUserExperience() -> Int16 {
        return userLevel[0].exp
    }
}

struct NewTestView_Previews: PreviewProvider {
    static var previews: some View {
        NewTestView()
    }
}
