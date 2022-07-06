//
//  Day77App.swift
//  Day77
//
//  Created by master on 7/6/22.
//

import SwiftUI

@main
struct Day77App: App {
    
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
