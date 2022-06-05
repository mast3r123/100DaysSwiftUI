//
//  ContentView.swift
//  Cupcake Corner
//
//  Created by master on 6/2/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var order = Orders()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.order.type) {
                        ForEach(Order.types.indices) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(order.order.qunatity)", value: $order.order.qunatity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special request?", isOn: $order.order.specialRequestEnabled.animation())
                    
                    if order.order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.order.extraFrosting)
                        Toggle("Add sprinkles", isOn: $order.order.addSprinkles)
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
