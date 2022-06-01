//
//  Habits.swift
//  HabitTracker
//
//  Created by master on 5/31/22.
//

import Foundation

class Habits: ObservableObject {
    
    @Published var habits = [HabitItem]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(habits) {
                UserDefaults.standard.set(encoded, forKey: "Habits")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Habits") {
            if let decodedItems = try? JSONDecoder().decode([HabitItem].self, from: savedItems) {
                habits = decodedItems
                return
            }
        }
        habits = []
    }
    
}
