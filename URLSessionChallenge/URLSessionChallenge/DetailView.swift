//
//  DetailView.swift
//  URLSessionChallenge
//
//  Created by master on 6/16/22.
//

import SwiftUI

struct DetailView: View {
    
    @State var user: CachedUser
    
    var body: some View {
        List {
            Section("Basic Info") {
                Text("Name: \(user.wrappedName)")
                Text("Company: \(user.wrappedCompany)")
                Text("Age: \(user.age)")
                Text("Email: \(user.wrappedEmail)")
                Text("Address: \(user.wrappedAddress)")
            }
            
            Section("About") {
                Text(user.wrappedAbout)
            }
            
            Section("Friends") {
                ForEach(user.friendsArray, id: \.id) { friend in
                    Text(friend.wrappedName)
                }
            }
        }.navigationBarTitleDisplayMode(.inline)
            .navigationTitle(user.wrappedName.components(separatedBy: " ").first!)
    }
}
