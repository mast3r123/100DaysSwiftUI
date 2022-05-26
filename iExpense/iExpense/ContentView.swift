//
//  ContentView.swift
//  iExpense
//
//  Created by master on 5/20/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    var sections: [String] { expenses.data.keys.map { $0 } }
    
    func rows(section: Int) -> [ExpenseItem] {
        expenses.data[sections[section]]!
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<sections.count, id: \.self) { section in
                    Section {
                        ForEach(rows(section: section)) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Spacer()
                                    Text(item.type)
                                }
                                Spacer()
                                Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(changeBackground(for: item.amount))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            
                        }
                        .onDelete { indexSet in
                            removeItems(section: section, row: indexSet)
                        }
                        
                    } header: {
                        Text(self.sections[section])
                            .font(.title3)
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expense: expenses)
            }
        }
    }
    
    func changeBackground(for amount: Double) -> Color {
        if (amount < 1000) {
            return .green
        } else if amount > 1000 && amount < 10000 {
            return .blue
        } else {
            return .red
        }
    }
    
    func removeItems(section: Int, row: IndexSet) {
        
        let section = sections[section]
        
        if let sec = expenses.data[section] {
            let id = sec[row.first!].id
            expenses.items.removeAll(where: { $0.id == id })
            print(expenses.items)
            print(expenses.data)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
