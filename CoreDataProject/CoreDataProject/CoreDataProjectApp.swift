//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by master on 6/13/22.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
