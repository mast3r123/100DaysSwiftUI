//
//  ContentView.swift
//  Unit Conversion
//
//  Created by master on 5/2/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var inputNumber: Double = 0
    
    enum Unit: String, CaseIterable, Identifiable {
        var id: Self { self }
        
        case KM
        case Meter
        case Feet
        case Yards
        case Miles
    }
    
    @State private var selectedInputUnit = Unit.KM
    @State private var selectedOutputUnit = Unit.Meter
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    @FocusState private var amountIsFocused: Bool
    
    var convertedUnit: Double {
        var baseMeterUnit: Double = 0
        
        switch selectedInputUnit {
        case .KM:
            baseMeterUnit = inputNumber * 1000
        case .Meter:
            baseMeterUnit = inputNumber
        case .Feet:
            baseMeterUnit = inputNumber * 0.3048
        case .Yards:
            baseMeterUnit = inputNumber * 0.9144
        case .Miles:
            baseMeterUnit = inputNumber * 1609.344
        }
        
        switch selectedOutputUnit {
        case .KM:
            return baseMeterUnit * 0.001
        case .Meter:
            return baseMeterUnit
        case .Feet:
            return baseMeterUnit * 3.28084
        case .Yards:
            return baseMeterUnit * 1.0936132983
        case .Miles:
            return baseMeterUnit * 0.000621371
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter your input", value: $inputNumber, formatter: formatter)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    Picker("Input Unit", selection: $selectedInputUnit) {
                        ForEach(Unit.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }.pickerStyle(.segmented)
                } header: {
                    Text("Input number")
                }
                
                Section {
                    Picker("Output Unit", selection: $selectedOutputUnit) {
                        ForEach(Unit.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }.pickerStyle(.segmented)
                    Text(convertedUnit, format: .number)
                } header: {
                    Text("Converted number")
                }
            }
            .navigationTitle("Unit Conversions")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
