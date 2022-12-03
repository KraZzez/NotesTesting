//
//  CoreDateFunctions.swift
//  Notes
//
//  Created by Ludvig Krantzén on 2022-12-03.
//

import SwiftUI
import CoreData

/*
class CoreDataFunctions {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Published var level: [UserLevel] = []
    
    init() {
        getUserLevel()
    }
    
    func getUserLevel() {
        let request = NSFetchRequest<UserLevel>(entityName: "UserLevel")
        
        do {
            level = try viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
}
*/

struct CoreDataFunctions: View {
    
    @Environment(\.managedObjectContext) private var viewContext
   // @State var level: [UserLevel] = []
    
    @State private var errorText = ""
    @State private var showError = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \UserLevel.exp, ascending: false)],
        animation: .default)
    private var level: FetchedResults<UserLevel>
    
    func addUserLevel() {
        withAnimation {
            let newUser = UserLevel(context: viewContext)
            newUser.exp = 0

            do {
                try viewContext.save()
            } catch {
                
            }
        }
    }
    
    func getCalculatedLevel() -> Int16 {
        let userLevel = level[0].exp / 10 + 1
        return (userLevel)
    }
    
    func getUserExperience() -> Int16 {
        let userExperience = level[0].exp
        return userExperience
    }
    
    /*
    
    func addUserLevel() {
        let newUserLevel = UserLevel(context: viewContext)
        newUserLevel.exp = 0
        save()
    }
 
    func updateUserLevel(points: Int16) {
        level[0].exp += points
        save()
    }
    
    func getUserLevel() {
        let request = NSFetchRequest<UserLevel>(entityName: "UserLevel")
        
        do {
            level = try viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func getCalculatedLevel() -> Int16 {
        let userLevel = level[0].exp / 10 + 1
        return (userLevel)
    }
    
    func getUserExperience() -> Int16 {
        let userExperience = level[0].exp
        return userExperience
    }
    
    private func save() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    } */
    var body: some View {
        VStack {
            Text("AJAJJA")
        }
    }
        
}
