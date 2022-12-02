//
//  Categories.swift
//  Notes
//
//  Created by Ludvig Krantzén on 2022-12-02.
//

import SwiftUI

struct Categories {
    
    func getCategoryImage(category: String) -> String{
        
        switch category {
        case "Fitness":
            return "figure.run"
        case "Chores":
            return "house"
        case "Health":
            return "heart"
        default:
            return "questionmark.app"
        }
    }
}
