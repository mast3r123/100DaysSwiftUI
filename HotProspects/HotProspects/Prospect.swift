//
//  Prospect.swift
//  HotProspects
//
//  Created by master on 7/13/22.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    var dateAdded = Date.now
}

@MainActor class Prospects: ObservableObject {
    
    @Published private(set) var people: [Prospect]
    
    var currentSorting = "By Names"
    
    let saveKey = "SavedData"
    
    init() {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("data.json")
            
            let data = try Data(contentsOf: fileURL)
            people = try JSONDecoder().decode([Prospect].self, from: data)
            sort(sortBy: currentSorting)
            return
        } catch {
            print("error reading data")
            people = []
        }
    }
    
    private func save() {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("data.json")
            
            try JSONEncoder()
                .encode(people)
                .write(to: fileURL)
        } catch {
            print("error writing data")
        }
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    func sort(sortBy: String) {
        currentSorting = sortBy
        if sortBy == "By Names" {
            people.sort{ $0.name < $1.name }
        } else {
            people.sort{ $0.dateAdded > $1.dateAdded }
        }
    }
    
    func add(prospect: Prospect) {
        people.append(prospect)
        sort(sortBy: currentSorting)
        save()
    }
}
