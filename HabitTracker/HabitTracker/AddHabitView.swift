//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by master on 5/31/22.
//

import SwiftUI

struct AddHabitView: View {
    
    @State private var name = ""
    @State private var description = ""
    @State private var amount = 0
    @State private var targetGoal = 0
    @ObservedObject var habit: Habits
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Description", text: $description)
                Stepper("\(targetGoal) days to complete", value: $targetGoal, in: 0...100)
            }
            .navigationTitle("Add Habit")
            .toolbar {
                Button("Save") {
                    let habitItem = HabitItem(name: name, description: description, amount: amount, targetGoal: targetGoal)
                    habit.habits.append(habitItem)
                    dismiss()
                }
            }
        }
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView(habit: Habits())
    }
}
