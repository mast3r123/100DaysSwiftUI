//
//  DetailView.swift
//  URLSessionChallenge
//
//  Created by master on 6/16/22.
//

import SwiftUI

struct DetailView: View {
    
    @State var user: User
    
    var body: some View {
        List {
            Section("Basic Info") {
                Text("Name: \(user.name)")
                Text("Company: \(user.company)")
                Text("Age: \(user.age)")
                Text("Email: \(user.email)")
                Text("Address: \(user.address)")
                Text("Member since: \(formatDate(for: user.registered))")
            }
            
            Section("About") {
                Text(user.about)
            }
            
            Section("Friends") {
                ForEach(user.friends, id: \.id) { friend in
                    Text(friend.name)
                }
            }
        }.navigationBarTitleDisplayMode(.inline)
            .navigationTitle(user.name.components(separatedBy: " ").first!)
    }
    
    func formatDate(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date)
    }
}
