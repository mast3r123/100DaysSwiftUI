//
//  ContentView.swift
//  Cupcake Corner
//
//  Created by master on 6/2/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var order = Order()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.item.type) {
                        ForEach(Item.types.indices) {
                            Text(Item.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(order.item.qunatity)", value: $order.item.qunatity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special request?", isOn: $order.item.specialRequestEnabled.animation())
                    
                    if order.item.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.item.extraFrosting)
                        Toggle("Add sprinkles", isOn: $order.item.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView(order: order)
                    } label: {
                        Text("Delivery Details")
                    }
                }
            }
            .navigationTitle("Cupcake corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
