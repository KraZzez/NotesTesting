//
//  ProfileView.swift
//  Notes
//
//  Created by Ludvig Krantzén on 2022-12-03.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \UserLevel.exp, ascending: false)],
        animation: .default)
    private var userLevel: FetchedResults<UserLevel>
    
    
    var body: some View {
        VStack {
            Text("Level: \(getCalculatedLevel())")
            Text("EXP: \(getUserExperience())")
        }
        .onAppear {
            if userLevel.count == 0 {
                addUserLevel()
            }
        }
    }
    
    func getCalculatedLevel() -> Int16 {
        return (userLevel[0].exp / 10 + 1)
    }
    
    func getUserExperience() -> Int16 {
        return (userLevel[0].exp)
    }
    
    func addUserLevel() {
        let newUserLevel = UserLevel(context: viewContext)
        newUserLevel.exp = 0
        do {
            try viewContext.save()
        } catch {
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
