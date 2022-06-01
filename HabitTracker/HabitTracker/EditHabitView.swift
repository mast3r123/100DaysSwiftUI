//
//  EditHabitView.swift
//  HabitTracker
//
//  Created by master on 5/31/22.
//

import SwiftUI

struct EditHabitView: View {
    
    @ObservedObject var habit: Habits
    @State var habitItem: HabitItem
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            TextField("Name", text: self.$habitItem.name)
            TextField("Description", text: self.$habitItem.description)
            Stepper("\(self.habitItem.amount) days completed", value: self.$habitItem.amount, in: 0...self.habitItem.targetGoal)
        }
        .navigationTitle("Edit Habit")
        .toolbar {
            Button("Save") {
                if let index = self.habit.habits.firstIndex(where: { $0.id == habitItem.id }) {
                    self.habit.habits[index] = habitItem
                    dismiss()
                }
            }
        }
    }
}

struct EditHabitView_Previews: PreviewProvider {
    static var previews: some View {
        EditHabitView(habit: Habits(), habitItem: Habits().habits.first!)
    }
}
