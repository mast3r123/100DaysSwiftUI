//
//  URLSessionChallengeApp.swift
//  URLSessionChallenge
//
//  Created by master on 6/16/22.
//

import SwiftUI

@main
struct URLSessionChallengeApp: App {
    
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
