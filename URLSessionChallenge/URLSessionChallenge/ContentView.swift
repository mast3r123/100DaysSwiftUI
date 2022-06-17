//
//  ContentView.swift
//  URLSessionChallenge
//
//  Created by master on 6/16/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var cachedUsers = [CachedUser]()
    
    @FetchRequest(entity: CachedUser.entity(), sortDescriptors: []) var user: FetchedResults<CachedUser>
    
    @Environment (\.managedObjectContext) var moc
    
    var body: some View {
        NavigationView {
            List(user, id: \.id) { usr in
                NavigationLink(destination: DetailView(user: usr)) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(usr.name ?? "")
                                .fontWeight(.bold)
                            Text(Image(systemName: "circle.fill"))
                                .foregroundColor(usr.isActive ? .green : .red)
                                .font(.system(size: 10))
                        }
                    }.padding(15)
                }
            }
            .navigationTitle("Users")
        }
        .onAppear{
            Task {
                await fetchData()
            }
        }
    }
    
    func fetchData() async {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let users = try decoder.decode([User].self, from: data)
            await MainActor.run {
                updateCoreData(users: users)
            }
        } catch {
            
        }
    }
    
    func updateCoreData(users: [User]) {
        for user in users {
            let cachedUser = CachedUser(context: moc)
            cachedUser.id = user.id
            cachedUser.isActive = user.isActive
            cachedUser.name = user.name
            cachedUser.registered = user.registered
            cachedUser.about = user.about
            cachedUser.company = user.company
            cachedUser.email = user.email
            cachedUser.about = user.about
            cachedUser.age = Int16(user.age)
            cachedUser.address = user.address
            
            for friend in user.friends {
                let cachedFriend = CachedFriend(context: moc)
                cachedFriend.id = friend.id
                cachedFriend.name = friend.name
                
                cachedUser.addToFriend(cachedFriend)
            }
        }
        
        try? moc.save()
    }
}
