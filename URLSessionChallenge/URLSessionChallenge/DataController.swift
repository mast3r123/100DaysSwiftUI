//
//  DataController.swift
//  URLSessionChallenge
//
//  Created by master on 6/17/22.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Details")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data Failed to load: \(error.localizedDescription)")
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
}
