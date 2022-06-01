//
//  ContentView.swift
//  HabitTracker
//
//  Created by master on 5/31/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var habits = Habits()
    @State private var showingAddHabits = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits.habits, id: \.self) { item in
                    NavigationLink(destination: EditHabitView(habit: habits, habitItem: item)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 15) {
                                Text(item.name)
                                    .font(.title3)
                                    .bold()
                                Text(item.description)
                            }
                            Spacer()
                            Text("\(item.amount) Days")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(backGroundColor(goalAmount: item.targetGoal, currentAmount: item.amount))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                }
                .onDelete { indexSet in
                    removeItems(row: indexSet)
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Habit Tracker")
            .toolbar {
                Button {
                    showingAddHabits = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddHabits) {
                AddHabitView(habit: habits)
            }
        }
    }
    
    func removeItems(row: IndexSet) {
        self.habits.habits.remove(atOffsets: row)
    }
    
    func backGroundColor(goalAmount: Int, currentAmount: Int) -> Color {
        if goalAmount > 3 {
            
            let colorRed = UIColor.red
            let colorBlue = UIColor.systemGreen
            
            let percent: CGFloat = CGFloat((100 * currentAmount) / goalAmount)
            return Color(colorRed.toColor(colorBlue, percentage: percent))
        }
        return .primary
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
