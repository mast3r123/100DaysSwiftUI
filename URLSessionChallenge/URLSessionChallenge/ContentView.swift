//
//  ContentView.swift
//  URLSessionChallenge
//
//  Created by master on 6/16/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var users = [User]()
    
    var body: some View {
        NavigationView {
            List(users, id: \.id) { user in
                NavigationLink(destination: DetailView(user: user)) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("\(user.name)")
                                .fontWeight(.bold)
                            Text(Image(systemName: "circle.fill"))
                            .foregroundColor(user.isActive ? .green : .red)
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
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, err in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                if let decodedResponse = try? decoder.decode([User].self, from: data) {
                    self.users = decodedResponse
                }
            }
        }.resume()
    }
}
