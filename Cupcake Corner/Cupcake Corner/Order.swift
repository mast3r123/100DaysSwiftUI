//
//  Order.swift
//  Cupcake Corner
//
//  Created by master on 6/3/22.
//

import SwiftUI

class Order: ObservableObject {
    @Published var item = Item()
}

struct Item: Codable {
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var qunatity = 3
    
     var specialRequestEnabled = false {
        didSet {
            if !specialRequestEnabled {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
     var extraFrosting = false
     var addSprinkles = false
    
     var name = ""
     var streetAdress = ""
     var city = ""
     var zip = ""
    
    var hasValidAddress: Bool {
        if name.trimmingCharacters(in: .whitespaces).isEmpty || streetAdress.trimmingCharacters(in: .whitespaces).isEmpty || city.trimmingCharacters(in: .whitespaces).isEmpty || zip.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        return true
    }
    
    var cost: Double {
        var cost = Double(qunatity) * 2
        
        cost += (Double(type) / 2)
        
        if extraFrosting {
            cost += Double(qunatity)
        }
        
        if addSprinkles {
            cost += Double(qunatity) / 2
        }
        return cost
    }
    
    init() {
        
    }
    
}
