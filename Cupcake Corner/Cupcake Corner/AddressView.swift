//
//  AddressView.swift
//  Cupcake Corner
//
//  Created by master on 6/3/22.
//

import SwiftUI

struct AddressView: View {
    
    @ObservedObject var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.item.name)
                TextField("Street Address", text: $order.item.streetAdress)
                TextField("City", text: $order.item.city)
                TextField("Zip", text: $order.item.zip)
            }
            
            Section {
                NavigationLink {
                    CheckoutView(order: order)
                } label: {
                    Text("Checkout")
                }
            }
            .disabled(!order.item.hasValidAddress)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
