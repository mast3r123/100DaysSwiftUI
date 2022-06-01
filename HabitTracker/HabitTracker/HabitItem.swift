//
//  HabitItem.swift
//  HabitTracker
//
//  Created by master on 5/31/22.
//

import Foundation

struct HabitItem: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var name: String
    var description: String
    var amount: Int
    var targetGoal: Int = 0
}
