//
//  Expenses.swift
//  iExpense
//
//  Created by master on 5/20/22.
//

import Foundation

class Expenses: ObservableObject {
    
    @Published var data = [String : [ExpenseItem]]()
    
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
            
            let personal = self.items.filter { $0.type == "Personal" }
            
            let business = self.items.filter { $0.type == "Business" }
            
            data["Personal"] = personal
            data["Business"] = business
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                
                return
            }
        }
        items = []
    }
    
}
