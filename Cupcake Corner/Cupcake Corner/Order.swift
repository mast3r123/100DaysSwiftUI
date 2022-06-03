//
//  Order.swift
//  Cupcake Corner
//
//  Created by master on 6/3/22.
//

import SwiftUI

class Order: ObservableObject {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    @Published var type = 0
    @Published var qunatity = 3
    
    @Published var specialRequestEnabled = false {
        didSet {
            if !specialRequestEnabled {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false
    
    @Published var name = ""
    @Published var streetAdress = ""
    @Published var city = ""
    @Published var zip = ""
    
    var hasValidAddress: Bool {
        if name.isEmpty || streetAdress.isEmpty || city.isEmpty || zip.isEmpty {
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
}
